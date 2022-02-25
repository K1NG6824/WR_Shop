#include <sourcemod>
#include <k1_weapon_reduce>
#include <shop>

public Plugin myinfo =
{
	name = "[Shop] Buy Immunity",
	author = "K1NG",
	version = "1.1",
	description = "http//projecttm.ru/"
};

public OnPluginStart()
{
	if (Shop_IsStarted())
		Shop_Started();
}

public void Shop_Started()
{
	
	char szBuffer[512];
	Shop_GetCfgFile(szBuffer, sizeof(szBuffer), "wr_immunity.cfg");

	KeyValues hKeyValues = new KeyValues("SHOP_K1WR");
	if (!hKeyValues.ImportFromFile(szBuffer))
	{
		SetFailState("Файл не найден");
		return;
	}
	char sName[64];
	char sCategory[64];
	char sDescription[128];
	KvGetString(hKeyValues, "name", sName, sizeof(sName), "Иммунитет к ограничению");
	KvGetString(hKeyValues, "category", sCategory, sizeof(sCategory), "wr_immunity");
	KvGetString(hKeyValues, "description", sDescription, sizeof(sDescription));

	if (KvGotoFirstSubKey(hKeyValues))
	{
		CategoryId category_id = Shop_RegisterCategory(sCategory, sName, sDescription);
		do
		{
			if (KvGetSectionName(hKeyValues, sName, sizeof(sName)) && Shop_StartItem(category_id, sName))
			{
				KvGetString(hKeyValues, "name", sName, sizeof(sName), sName);
				KvGetString(hKeyValues, "description", sDescription, sizeof(sDescription));
				Shop_SetCustomInfo("wr_immunity", 1);
				Shop_SetInfo(sName, sDescription, KvGetNum(hKeyValues, "price", 1000), KvGetNum(hKeyValues, "sell", 10), Item_Togglable, hKeyValues.GetNum("duration", 0), KvGetNum(hKeyValues, "price_gold", -1), KvGetNum(hKeyValues, "sell_gold", -1));
				Shop_SetHide(!!hKeyValues.GetNum("hide", 0));
				Shop_SetCallbacks(_, OnEquipItem, _, _, _, _, OnBuyItem, ItemSellCallback, Shop_OnItemElapsed);
				Shop_EndItem();
			}
		} while (KvGotoNextKey(hKeyValues));
	}

	delete hKeyValues;
}

public bool ItemSellCallback(int client, CategoryId category_id, const char[] category, ItemId item_id, const char[] item, ItemType type, int sell_price)
{
	if(K1_WR_IsStarted())
    {
        if(K1_WR_TakeImmunity(client))
		{
			if(!K1_WR_CheckImmunity(client))
            	K1_WR_DropWeapon(client);

			return true;
		}
    }
	return false;
}

public bool OnBuyItem(int iClient, CategoryId category_id, const char[] category, ItemId item_id, const char[] item, ItemType type, int price, int sell_price, int value, int price_gold, int sell_price_gold)
{
	if(!K1_WR_IsStarted())
		return false;

	return true;
}

public Shop_OnItemElapsed(int iClient, CategoryId category_id, const char[] category, ItemId item_id, const char[] item)
{
	if(K1_WR_IsStarted())
    {
        if(K1_WR_TakeImmunity(iClient) && !K1_WR_CheckImmunity(iClient))
            K1_WR_DropWeapon(iClient);
    }
}

public ShopAction OnEquipItem(int iClient, CategoryId category_id, const char[] category, ItemId item_id, const char[] item, bool isOn, bool elapsed) 
{
    ArrayList hLocalArray = Shop_GetClientItems(iClient);
	if (isOn || elapsed)
	{
		if(K1_WR_IsStarted())
        {
			K1_WR_TakeImmunity(iClient);
			if(!K1_WR_CheckImmunity(iClient))
				K1_WR_DropWeapon(iClient);

	        return Shop_UseOff;
        }
		return Shop_UseOff;
	}

	if(K1_WR_IsStarted())
    {
        if(K1_WR_GiveImmunity(iClient))
	        return Shop_UseOn;  
    }
    return Shop_UseOff;
}

public OnPluginEnd() 
{
	Shop_UnregisterMe();
}