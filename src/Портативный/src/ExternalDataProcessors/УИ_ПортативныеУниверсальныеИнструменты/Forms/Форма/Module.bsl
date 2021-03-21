﻿// Хранилище глобальных переменных.
//
// ПараметрыПриложения - Соответствие - хранилище переменных, где:
//   * Ключ - Строка - имя переменной в формате "ИмяБиблиотеки.ИмяПеременной";
//   * Значение - Произвольный - значение переменной.
//
// Инициализация (на примере СообщенияДляЖурналаРегистрации):
//   ИмяПараметра = "СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации";
//   Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
//     ПараметрыПриложения.Вставить(ИмяПараметра, Новый СписокЗначений);
//   КонецЕсли;
//  
// Использование (на примере СообщенияДляЖурналаРегистрации):
//   ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"].Добавить(...);
//   ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"] = ...;
&НаКлиенте
Перем УИ_ПараметрыПриложения_Портативные Экспорт;
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОбработкаОбъект=РеквизитФормыВЗначение("Объект");

	Файл=Новый Файл(ОбработкаОбъект.ИспользуемоеИмяФайла);
	КаталогИнструментов=Файл.Путь;

	СоздатьКомандыОткрытияИнструментовНаФорме();

	Заголовок=Версия();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПодключитьВнешниеМодули();
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	УИ_ОбщегоНазначенияКлиент.ПриЗавершенииРаботыСистемы();
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ЗаголовокЭлементаИнструмента(Имя, Синоним, ТекстПоиска = "")
	Заголовок=Синоним;
	Если Не ЗначениеЗаполнено(Заголовок) Тогда
		Заголовок=Имя;
	КонецЕсли;

	Если ЗначениеЗаполнено(ТекстПоиска) Тогда
		ЗаголовокИзначальный=Заголовок;
		ЗаголовокДляПоиска=НРег(ЗаголовокИзначальный);
		НовыйЗаголовок="";
		ДлинаСтрокиПоиска=СтрДлина(ТекстПоиска);

		ПозицияСимвола=СтрНайти(ЗаголовокДляПоиска, ТекстПоиска);
		Пока ПозицияСимвола > 0 Цикл
			ФорматированнаяСтрокаПоиска=Новый ФорматированнаяСтрока(Сред(ЗаголовокИзначальный, ПозицияСимвола,
				ДлинаСтрокиПоиска), Новый Шрифт(, , , Истина), WebЦвета.Красный);
			НовыйЗаголовок=Новый ФорматированнаяСтрока(НовыйЗаголовок, Лев(ЗаголовокИзначальный, ПозицияСимвола - 1),
				ФорматированнаяСтрокаПоиска);

			ЗаголовокИзначальный=Сред(ЗаголовокИзначальный, ПозицияСимвола + ДлинаСтрокиПоиска);
			ЗаголовокДляПоиска=НРег(ЗаголовокИзначальный);

			ПозицияСимвола=СтрНайти(ЗаголовокДляПоиска, ТекстПоиска);

		КонецЦикла;

		Если ЗначениеЗаполнено(НовыйЗаголовок) Тогда
			НовыйЗаголовок=Новый ФорматированнаяСтрока(НовыйЗаголовок, ЗаголовокИзначальный);
			Заголовок=НовыйЗаголовок;
		КонецЕсли;
	КонецЕсли;
	Возврат Заголовок;
КонецФункции


&НаКлиенте
Процедура ОбработатьПоиск(СтрокаПоискаПереданная)
	СортированныйСписок=СортированныйСписокМодулейИнструментовДляКнопок();
	
	Поиск=СокрЛП(НРег(СтрокаПоискаПереданная));
	
	Для Каждого ЭлементСпискаИнструментов Из СортированныйСписок Цикл
		ВидимостьЭлемента=Истина;
		Если ЗначениеЗаполнено(Поиск) Тогда
			ВидимостьЭлемента=СтрНайти(НРег(ЭлементСпискаИнструментов.Значение), Поиск) > 0 Или СтрНайти(
				НРег(ЭлементСпискаИнструментов.Представление), Поиск) > 0;
		КонецЕсли;

		Элементы[ЭлементСпискаИнструментов.Значение].Видимость=ВидимостьЭлемента;
		Элементы[ЭлементСпискаИнструментов.Значение].Заголовок=ЗаголовокЭлементаИнструмента(
			ЭлементСпискаИнструментов.Значение, ЭлементСпискаИнструментов.Представление, Поиск);
	КонецЦикла;

КонецПроцедуры


&НаКлиенте
Процедура СтрокаПоискаОчистка(Элемент, СтандартнаяОбработка)
	ОбработатьПоиск("");
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	СтрокаПоиска=Текст;
	ОбработатьПоиск(Текст);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьКомандуИнструмента(Команда)
	ОписанияМодулей=ОписаниеМодулейИнструментовДляПодключения();
	ОписаниеМодуля=ОписанияМодулей[Команда.Имя];

	Если ОписаниеМодуля.Вид = "Отчет" Тогда
		ОткрытьФорму("ВнешнийОтчет." + Команда.Имя + ".Форма", , ЭтаФорма);
	Иначе
		ОткрытьФорму("ВнешняяОбработка." + Команда.Имя + ".Форма", , ЭтаФорма);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СоздатьКомандыОткрытияИнструментовНаФорме()
	ОписаниеИнструментов=СортированныйСписокМодулейИнструментовДляКнопок();
	ОписаниеМодулей=ОписаниеМодулейИнструментовДляПодключения();

	Четный=Ложь;
	Для Каждого ЭлементСписка Из ОписаниеИнструментов Цикл
		Описание=ОписаниеМодулей[ЭлементСписка.Значение];
		
		Если Описание.НеВыводитьВИнтерфейс Тогда
			Продолжить;
		КонецЕсли;
		
		Если Четный Тогда
			Родитель=Элементы.ГруппаКомандыИнструментовПраво;
		Иначе
			Родитель=Элементы.ГруппаКомандыИнструментовЛево;
		КонецЕсли;

		Элемент=Элементы.Добавить(Описание.Имя, Тип("ДекорацияФормы"), Родитель);
		//Элемент.ИмяКоманды=Описание.Имя;
		Элемент.Заголовок=ЗаголовокЭлементаИнструмента(Описание.Имя, Описание.Синоним);
		Элемент.Вид=ВидДекорацииФормы.Надпись;
		Элемент.Гиперссылка=Истина;
		Элемент.Подсказка=Описание.Подсказка;
		Элемент.ОтображениеПодсказки=ОтображениеПодсказки.ОтображатьСнизу;
		Элемент.УстановитьДействие("Нажатие","Подключаемый_ОткрытьКомандуИнструмента");

		Четный=Не Четный;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ВопросРазработчику(Команда)
	ОткрытьФорму("Обработка.УИ_ТехПоддержка.Форма");
КонецПроцедуры

&НаКлиенте
Процедура СтраницаРазработки(Команда)
	УИ_ОбщегоНазначенияКлиент.ОткрытьСтраницуРазработки();
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьНеобходимостьОбновления(Команда)
	УИ_ОбщегоНазначенияКлиент.ЗапуститьПроверкуОбновленияИнструментов();
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция НовыйОписаниеМодуля() Экспорт
	Описание=Новый Структура;
	Описание.Вставить("Имя", "");
	Описание.Вставить("Синоним", "");
	Описание.Вставить("ИмяФайла", "");
	Описание.Вставить("Подсказка", "");
	Описание.Вставить("НеВыводитьВИнтерфейс", Ложь);
	Описание.Вставить("Тип", "Инструмент");
	Описание.Вставить("Вид", "Обработка");
	Описание.Вставить("Команды", Неопределено);

	Возврат Описание;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеМодулейИнструментовДляПодключения()
	Описания=Новый Структура;
	
	// МЕТОД ГЕНЕРИРУЕТСЯ ПРИ СБОРКЕ
	
//	ОписаниеИнструмента=НовыйОписаниеМодуля();
//	ОписаниеИнструмента.Имя="УИ_РедакторСКД";
//	Описания.Вставить(ОписаниеИнструмента.Имя,ОписаниеИнструмента);
//	
//	ОписаниеИнструмента=НовыйОписаниеМодуля();
//	ОписаниеИнструмента.Имя="УИ_КонсольОтчетов";
//	ОписаниеИнструмента.Вид="Отчет";
//	Описания.Вставить(ОписаниеИнструмента.Имя,ОписаниеИнструмента);
//	
//	ОписаниеИнструмента=НовыйОписаниеМодуля();
//	ОписаниеИнструмента.Имя="УИ_БуферОбменаКлиент";
//	ОписаниеИнструмента.Тип="ОбщийМодуль";
//	Описания.Вставить(ОписаниеИнструмента.Имя,ОписаниеИнструмента);
//	
//	ОписаниеИнструмента=НовыйОписаниеМодуля();
//	ОписаниеИнструмента.Имя="УИ_ОбщегоНазначенияКлиент";
//	ОписаниеИнструмента.Тип="ОбщийМодуль";
//	Описания.Вставить(ОписаниеИнструмента.Имя,ОписаниеИнструмента);
//	ОписаниеИнструмента=НовыйОписаниеМодуля();
//	
//	ОписаниеИнструмента.Имя="УИ_ОбщегоНазначенияКлиентСервер";
//	ОписаниеИнструмента.Тип="ОбщийМодуль";
//	Описания.Вставить(ОписаниеИнструмента.Имя,ОписаниеИнструмента);
//	
//	ОписаниеИнструмента=НовыйОписаниеМодуля();
//	ОписаниеИнструмента.Имя="УИ_РаботаСФормами";
//	ОписаниеИнструмента.Тип="ОбщийМодуль";
//	Описания.Вставить(ОписаниеИнструмента.Имя,ОписаниеИнструмента);

	Возврат Описания;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция СортированныйСписокМодулейИнструментовДляКнопок()
	ОписаниеМодулей=ОписаниеМодулейИнструментовДляПодключения();
	
	СписокМодулей=Новый СписокЗначений();
	
	Для Каждого КлючЗначение Из ОписаниеМодулей Цикл
		Описание=КлючЗначение.Значение;
		Если Описание.Тип <> "Инструмент" Тогда
			Продолжить;
		КонецЕсли;
		Если Описание.НеВыводитьВИнтерфейс Тогда
			Продолжить;
		КонецЕсли;
		
		СписокМодулей.Добавить(Описание.Имя, Описание.Синоним);
	КонецЦикла;
	
	СписокМодулей.СортироватьПоПредставлению();
	Возврат СписокМодулей;
КонецФункции

&НаКлиенте
Функция ИмяФайлаМодуля(ОписаниеМодуля)
	Если ОписаниеМодуля.Тип = "ОбщийМодуль" Тогда
		КаталогМодуля="ОбщиеМодули";
	ИначеЕсли ОписаниеМодуля.Тип="ОбщаяКартинка" Тогда
		Возврат КаталогИнструментов+ПолучитьРазделительПути()+"Картинки"+ПолучитьРазделительПути()+ОписаниеМодуля.ИмяФайла;
	Иначе
		КаталогМодуля="Инструменты";
	КонецЕсли;

	Если ОписаниеМодуля.Вид = "Отчет" Тогда
		Расширение="erf";
	Иначе
		Расширение="epf";
	КонецЕсли;

	Возврат КаталогИнструментов + ПолучитьРазделительПути() + КаталогМодуля + ПолучитьРазделительПути()
		+ ОписаниеМодуля.Имя + "." + Расширение;
КонецФункции

&НаКлиенте
Процедура ПодключитьВнешниеМодули()
	Описание=ОписаниеМодулейИнструментовДляПодключения();

	ПомещаемыеФайлы=Новый Массив;

	Для Каждого КлючЗначение Из Описание Цикл
		ТекОписаниеИнструмента=КлючЗначение.Значение;
		ПомещаемыеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(ИмяФайлаМодуля(ТекОписаниеИнструмента)));
	КонецЦикла;

	НачатьПомещениеФайлов(Новый ОписаниеОповещения("ПодключитьВнешниеМодулиЗавершение", ЭтаФорма,
		Новый Структура("ОписаниеИнструментов", Описание)), ПомещаемыеФайлы, , Ложь, УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьВнешниеМодулиЗавершение(ПомещенныеФайлы, ДополнительныеПараметры) Экспорт
	Если ПомещенныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;

	УИ_БиблиотекаКартинок=Новый Структура;

	МодулиДляПодключенияНаСервере=Новый Массив;

	Для Каждого ПомещенныйФайл Из ПомещенныеФайлы Цикл
		Если ВерсияПлатформыНеМладше("8.3.13") Тогда
			ИмяФайла = ПомещенныйФайл.ПолноеИмя;
		Иначе
			ИмяФайла = ПомещенныйФайл.Имя;
		КонецЕсли;
		
		Файл=Новый Файл(ИмяФайла);
		Если НРег(Файл.Расширение) = ".erf" Тогда
			МодулиДляПодключенияНаСервере.Добавить(Новый Структура("ЭтоОтчет, Адрес", Истина, ПомещенныйФайл.Хранение));
		ИначеЕсли НРег(Файл.Расширение) = ".epf" Тогда
			МодулиДляПодключенияНаСервере.Добавить(Новый Структура("ЭтоОтчет, Адрес", Ложь, ПомещенныйФайл.Хранение));
		Иначе
			УИ_БиблиотекаКартинок.Вставить(Файл.ИмяБезРасширения, Новый Картинка(Файл.ПолноеИмя));
			Продолжить;
		КонецЕсли;
	КонецЦикла;

	ПодключитьВнешниеМодулиНаСервере(МодулиДляПодключенияНаСервере);
	//Теперь можно использовать общие модули

	АдресЛокальнойБиблиотекиКартинок=ПоместитьВоВременноеХранилище(УИ_БиблиотекаКартинок, УникальныйИдентификатор);
	ЗаписатьАдресЛокальнойБиблиотекиКартинокВХранилищеНастроек(АдресЛокальнойБиблиотекиКартинок);

	УИ_ОбщегоНазначенияКлиент.ПриНачалеРаботыСистемы();

	Элементы.ГруппаСтраницыФормы.ТекущаяСтраница=Элементы.ГруппаСтраницаРаботыСИнструментами;
КонецПроцедуры

&НаСервере
Процедура ПодключитьВнешниеМодулиНаСервере(МодулиДляПодключенияНаСервере)
	Для Каждого ВнешнийМодуль ИЗ МодулиДляПодключенияНаСервере Цикл
		ПодключитьВнешнююОбработку(ВнешнийМодуль.Адрес, ВнешнийМодуль.ЭтоОтчет);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ПодключитьВнешнююОбработку(АдресХранилища, ЭтоОтчет)

	ОписаниеЗащитыОтОпасныхДействий =Новый ОписаниеЗащитыОтОпасныхДействий;
	ОписаниеЗащитыОтОпасныхДействий.ПредупреждатьОбОпасныхДействиях=Ложь;
	Если ЭтоОтчет Тогда
		Возврат ВнешниеОтчеты.Подключить(АдресХранилища, , Ложь, ОписаниеЗащитыОтОпасныхДействий);
	Иначе
		Возврат ВнешниеОбработки.Подключить(АдресХранилища, , Ложь, ОписаниеЗащитыОтОпасныхДействий);
	КонецЕсли;
КонецФункции

&НаСервере
Процедура ЗаписатьАдресЛокальнойБиблиотекиКартинокВХранилищеНастроек(Адрес)
	УИ_ОбщегоНазначения.ХранилищеНастроекДанныхФормСохранить(
		УИ_ОбщегоНазначенияКлиентСервер.КлючОбъектаВХранилищеНастроек(), "АдресЛокальнойБиблиотекиКартинок", Адрес, ,
		ИмяПользователя());
КонецПроцедуры

&НаКлиенте
Функция ВерсияПлатформыНеМладше(ВерсияДляСравнения) Экспорт
	ВерсияБезСборки=ВерсияКонфигурацииБезНомераСборки(ТекущаяВерсияПлатформы1СПредприятие());

	Возврат СравнитьВерсииБезНомераСборки(ВерсияБезСборки, ВерсияДляСравнения)>=0;
КонецФункции

&НаКлиенте
Функция ВерсияКонфигурацииБезНомераСборки(Знач Версия) Экспорт

	Массив = СтрРазделить(Версия, ".");

	Если Массив.Количество() < 3 Тогда
		Возврат Версия;
	КонецЕсли;

	Результат = "[Редакция].[Подредакция].[Релиз]";
	Результат = СтрЗаменить(Результат, "[Редакция]", Массив[0]);
	Результат = СтрЗаменить(Результат, "[Подредакция]", Массив[1]);
	Результат = СтрЗаменить(Результат, "[Релиз]", Массив[2]);

	Возврат Результат;
КонецФункции

&НаКлиенте
Функция ТекущаяВерсияПлатформы1СПредприятие() Экспорт

	СистИнфо = Новый СистемнаяИнформация;
	Возврат СистИнфо.ВерсияПриложения;

КонецФункции

// Сравнить две строки версий.
//
// Параметры:
//  СтрокаВерсии1  - Строка - номер версии в формате РР.{П|ПП}.ЗЗ.
//  СтрокаВерсии2  - Строка - второй сравниваемый номер версии.
//
// Возвращаемое значение:
//   Число   - больше 0, если СтрокаВерсии1 > СтрокаВерсии2; 0, если версии равны.
//
&НаКлиенте
Функция СравнитьВерсииБезНомераСборки(Знач СтрокаВерсии1, Знач СтрокаВерсии2) Экспорт

	Строка1 = ?(ПустаяСтрока(СтрокаВерсии1), "0.0.0", СтрокаВерсии1);
	Строка2 = ?(ПустаяСтрока(СтрокаВерсии2), "0.0.0", СтрокаВерсии2);
	Версия1 = СтрРазделить(Строка1, ".");
	Если Версия1.Количество() <> 3 Тогда
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Неправильный формат параметра СтрокаВерсии1: %1'"), СтрокаВерсии1);
	КонецЕсли;
	Версия2 = СтрРазделить(Строка2, ".");
	Если Версия2.Количество() <> 3 Тогда
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Неправильный формат параметра СтрокаВерсии2: %1'"), СтрокаВерсии2);
	КонецЕсли;

	Результат = 0;
	Для Разряд = 0 По 2 Цикл
		Результат = Число(Версия1[Разряд]) - Число(Версия2[Разряд]);
		Если Результат <> 0 Тогда
			Возврат Результат;
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция Версия() Экспорт

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция Поставщик() Экспорт

КонецФункции








УИ_ПараметрыПриложения_Портативные = Новый Соответствие;
