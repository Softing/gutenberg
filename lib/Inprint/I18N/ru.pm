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
    "Catalog"               => "Каталог",
    "Calendar"              => "Календарь",
    "Capture"               => "Захват",
    "Card"                  => "Карточка",
    "Cancel"                => "Отменить",
    "Change"                => "Изменить",
    "Company news"          => "Новости компании",
    "Copy"                  => "Копировать",
    "Close"                 => "Закрыть",
    "Close this panel"      => "Закрыть эту панель",
    "Create"                => "Создать",
    "Color"                 => "Цвет",
    "Documents"             => "Документы",
    "Departments"           => "Отделы",
    "Delete"                => "Удалить",
    "Description"           => "Описание",
    "Disable"               => "Выключить",
    "Duplicate"             => "Дублировать",
    "Edit"                  => "Редактировать",
    "Edit profile"          => "Редактировать профиль",
    "Editions"              => "Издания",
    "Employee"              => "Сотрудник",
    "Employees"             => "Сотрудники",
    "Employees online"      => "Сотрудники онлайн",
    "Enable"                => "Включить",
    "Enter"                 => "Войти",
    "Enter login"           => "Введите логин",
    "Exchange"              => "Обмен",
    "Fascicle"              => "Выпуск",
    "Group"                 => "Группа",
    "Group access"          => "Правила группы",
    "Headline"              => "Раздел",
    "Help"                  => "Помощь",
    "Inprint"               => "Инпринт",
    "Limit"                 => "Ограничение",
    "Limitation..."         => "Ограничение...",
    "Logs"                  => "Логи",
    "Loading"               => "Загрузка",
    "Login"                 => "Логин",
    "Logout"                => "Выход",
    "Manager"               => "Редактор",
    "Members"               => "Участники",
    "My alerts"             => "Мои события",
    "Name"                  => "Имя",
    "No"                    => "Нет",
    "Owner"                 => "Владелец",
    "Pages"                 => "Полосы",
    "Password"              => "Пароль",
    "Plan"                  => "План",
    "Planning"              => "Планирование",
    "Portal"                => "Портал",
    "Profile"               => "Профиль",
    "Progress"              => "Готовность",
    "Publishing House"      => "Издательский дом",
    "Recycle"               => "Корзина",
    "Recycle Bin"           => "Корзина",
    "Remove"                => "Удалить",
    "Restore"               => "Восстановить",
    "Rubric"                => "Рубрика",
    "Rule"                  => "Правило",
    "Rules"                 => "Правила",
    "Refresh this panel"    =>"Обновить эту панель",
    "Roles"                 => "Роли",
    "Rubrics"               => "Рубрики",
    "Settings"              => "Настройки",
    "Save"                  => "Сохранить",
    "Select chain"          => "Выберите цепочку",
    "Select employees"      => "Выберите сотрудников",
    "Short title"           => "Краткое название",
    "Short"                 => "Кратко",
    "Shortcut"              => "Ярлык",
    "Show archvies"         => "Показать архивы",
    "Suitable data is not found" => "Подходящие данные не найдены",
    "Todo"                  => "Сделать",
    "Title"                 => "Название",
    "Transfer"              => "Передача",
    "Yes"                   => "Да",
    "Wrong password"        => "Пароль не верен",

    "No documents to display" => "Документы не найдены",
    "Displaying documents {0} - {1} of {2}" => "Показаны материалы {0} - {1} из {2}",
    

);

sub getAll {
    return \%Lexicon;
}

1;
