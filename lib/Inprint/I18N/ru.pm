package Inprint::I18N::ru;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use base 'Inprint::I18N';

use utf8;

our %Lexicon = (
    "About"                 => "О программе",
    "Access"                => "Доступ",
    "Add"                   => "Добавить",
    "Advertising"           => "Реклама",
    "Adjustment"            => "Настройка",
    "All"                   => "Все",
    "Archive"               => "Архив",
    "Briefcase"             => "Портфель",
    "Calendar"              => "Календарь",
    "Card"                  => "Карточка",
    "Cancel"                => "Отменить",
    "Company news"          => "Новости компании",
    "Close"                 => "Закрыть",
    "Close this panel"      => "Закрыть эту панель",
    "Create"                => "Создать",
    "Color"                 => "Цвет",
    "Documents"             => "Документы",
    "Departments"           => "Отделы",
    "Description"           => "Описание",
    "Disable"               => "Выключить",
    "Editions"              => "Издания",
    "Employees"             => "Сотрудники",
    "Employees online"      => "Сотрудники онлайн",
    "Enable"                => "Включить",
    "Enter"                 => "Войти",
    "Enter login"           => "Введите логин",
    "Exchange"              => "Обмен",
    "Help"                  => "Помощь",
    "Inprint"               => "Инпринт",
    "Logs"                  => "Логи",
    "Loading"               => "Загрузка",
    "Login"                 => "Логин",
    "Logout"                => "Выход",
    "My alerts"             => "Мои события",
    "No"                    => "Нет",
    "Password"              => "Пароль",
    "Plan"                  => "План",
    "Planning"              => "Планирование",
    "Portal"                => "Портал",
    "Recycle"               => "Корзина",
    "Remove"                => "Удалить",
    "Refresh this panel"    =>"Обновить эту панель",
    "Roles"                 => "Роли",
    "Rubrics"               => "Рубрики",
    "Settings"              => "Настройки",
    "Save"                  => "Сохранить",
    "Short title"           => "Краткое название",
    "Short"                 => "Кратко",
    "Todo"                  => "Сделать",
    "Title"                 => "Название",
    "Yes"                   => "Да",
    "Wrong password"        => "Пароль не верен"
    
);

sub getAll {
    return \%Lexicon;
}

1;