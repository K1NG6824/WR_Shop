#if defined _k1_weapon_reduce
    #endinput 
#endif 
#define _k1_weapon_reduce

/**
 *	Проверка что ядро загружено и готово к регистрации функций.
 *	-
 * @noparams
 *	-
 * @return					true - Ядро загружено.
 * 							false - Ядро не загружено.
*/
native bool K1_WR_IsStarted();

/**
 *	Вызывается когда K1_WS-плагин загрузился.
 *	-
 * @noparams
 *	-
 * @noreturn
*/
forward void K1_WR_Started();



/**
 *	Выдать иммунитет.
 *	-
 * @param iClient			Индекс игрока.
 *	-
 * @return					true - Успешно выдано false - игрок не валидный
*/

native bool K1_WR_GiveImmunity(int iClient);

/**
 *	Забрать иммунитет.
 *	-
 * @param iClient			Индекс игрока.
 *	-
 * @return					true - Успешно забрано false - ошибка либо игрок не имеет иммунитет.
*/

native bool K1_WR_TakeImmunity(int iClient);

/**
 *	Проверить иммунитет.
 *	-
 * @param iClient			Индекс игрока.
 *	-
 * @return					1 - Количество выданных иммунитетов у игрока -1 - Игрок не валидный.
*/

native bool K1_WR_CheckImmunity(int iClient);

/**
 *	Изменить статус ограничения.
 *	-
 * @param iStatus			Статус ограничения 0 - Работает 1 - Отключено
 *	-
 * @return					true - Успешно
*/

native bool K1_WR_ChangeStatus(int iStatus);

/**
 *	Изменить статус ограничения для конкретного оружия
 *	-
 * @param iStatus			0 - Работает ограничение для оружия вообще 1 - Отключено ограничение для оружия вообще  2 - Удалить ограничение для конкретного оружия 3 - Добавить ограничение для конкретного оружия
 * @param iWeapon			Id оружия (найти можно выше) 
 * @param iPlayers			Количество игроков
 * @param iCount			Количество оружия
 *	-
 * @return					true - Успешно изменено false - Неверное оружие указано либо не найдена запись с количеством игроков для статуса 2
*/

native bool K1_WR_ChangeStatusWeapon(int iStatus, int iWeapon, int iPlayers, int iCount);

/**
 *	Выбросить оружие
 *	-
 * @param iClient			Индекс игрока.
 *	-
 * @return					true - Оружие было выброшено false - Либо запретного оружия нет либо не валидный игрок
*/
native bool K1_WR_DropWeapon(int iClient);


public SharedPlugin __pl_k1_wr = 
{
	name = "k1_wr",
	file = "WR_Core.smx",

	#if defined REQUIRE_PLUGIN
		required = 1
	#else
		required = 0
	#endif
};

#if !defined REQUIRE_PLUGIN
public void __pl_k1_wr_SetNTVOptional()
{
	MarkNativeAsOptional("K1_WR_GiveImmunity");
	MarkNativeAsOptional("K1_WR_TakeImmunity");
	MarkNativeAsOptional("K1_WR_CheckImmunity");
	MarkNativeAsOptional("K1_WR_IsStarted");
	MarkNativeAsOptional("K1_WR_ChangeStatus");
	MarkNativeAsOptional("K1_WR_ChangeStatusWeapon");
	MarkNativeAsOptional("K1_WR_DropWeapon");
}
#endif