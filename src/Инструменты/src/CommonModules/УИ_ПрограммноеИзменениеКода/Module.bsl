
#Область ПрограммныйИнтерфейс

// Заменить переменные в тексте.
// 
// Параметры:
//  Исходник - Строка - Исходник
//  ЗаменяемыеПеременные -Структура Из КлючИЗначение:
//  	* Ключ - Строка - текущее имя переменной
//  	* Значение - Строка - Новое имя переменной
// 
// Возвращаемое значение:
//  Строка
Функция ЗаменитьПеременныеВТексте(Исходник, ЗаменяемыеПеременные) Экспорт
	ПараметрыПлагинов = Новый Структура;
	ПараметрыПлагинов.Вставить("ПереименованиеПеременных", ЗаменяемыеПеременные);
	Возврат РезультатИзмененияТекста(Исходник, ПараметрыПлагинов);

КонецФункции

// Выполнить изменение текста.
// 
// Параметры:
//  Исходник -Строка -Исходник
//  ПараметрыПлагинов - Структура Из КлючИЗначение:
//  	* Ключ - Строка - Имя плагина
//  	* Значение - Произвольный - Параметры плагина
// 
// Возвращаемое значение:
//  Строка
Функция РезультатИзмененияТекста(Исходник, ПараметрыПлагинов) Экспорт
	Парсер = Обработки.УИ_ПарсерВстроенногоЯзыка.Создать();
	
	Плагины = Новый Массив();
	ПараметрыПлагиновИсполнения = Новый Соответствие;

	Для Каждого КлючЗначение Из ПараметрыПлагинов Цикл
		ТекПлагин = НовыйПлагинПарсераВстроенногоЯзыка(КлючЗначение.Ключ);
		
		Плагины.Добавить(ТекПлагин);
		ПараметрыПлагиновИсполнения[ТекПлагин.ЭтотОбъект] = КлючЗначение.Значение;
	КонецЦикла;

	Парсер.Пуск(Исходник, Плагины, ПараметрыПлагиновИсполнения);
	
	Замены = Парсер.ТаблицаЗамен();
	Если Замены.Количество() > 0 Тогда
		Возврат Парсер.ВыполнитьЗамены();
	КонецЕсли;
	
	Возврат Исходник;	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Код процедур и функций

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Новый плагин парсера встроенного языка.
// 
// Параметры:
//  ИмяПлагина - Строка - Имя плагина
// 
// Возвращаемое значение:
//  ВнешняяОбработка
// Возвращаемое значение:
//  Неопределено - Не удалось подключить плагин
Функция НовыйПлагинПарсераВстроенногоЯзыка(ИмяПлагина)
	ИмяПодключаемойОбработки = ИмяПодключаемойОбработкиПлагинаПарсераВстроенногоЯзыка(ИмяПлагина);
	Попытка
		Возврат ВнешниеОбработки.Создать(ИмяПодключаемойОбработки);
	Исключение
		Попытка
			ПодключитьПлагинКСеансу(ИмяПлагина);
			Возврат ВнешниеОбработки.Создать(ИмяПодключаемойОбработки);
		Исключение
			Возврат Неопределено;
		КонецПопытки;
	КонецПопытки;
КонецФункции

// Подключить плагин к сеансу.
// 
// Параметры:
//  ИмяПлагина -Строка -Имя плагина
Процедура ПодключитьПлагинКСеансу(ИмяПлагина)
	ДвоичныеДанныеПлагина = Обработки.УИ_ПарсерВстроенногоЯзыка.ПолучитьМакет("Плагин_" + ИмяПлагина);
	АдресПлагинаВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанныеПлагина);

	ОписаниеЗащитыОтОпасныхДействий = Новый ОписаниеЗащитыОтОпасныхДействий;
	ОписаниеЗащитыОтОпасныхДействий.ПредупреждатьОбОпасныхДействиях=Ложь;
	ВнешниеОбработки.Подключить(АдресПлагинаВоВременномХранилище,
								ИмяПодключаемойОбработкиПлагинаПарсераВстроенногоЯзыка(ИмяПлагина),
								Ложь,
								ОписаниеЗащитыОтОпасныхДействий);
	
КонецПроцедуры

Функция ИмяПодключаемойОбработкиПлагинаПарсераВстроенногоЯзыка(ИмяПлагина)
	Возврат ПрефиксПодключаемойОбработкиПлагина()+"_"+ВРег(ИмяПлагина);	
КонецФункции

Функция ПрефиксПодключаемойОбработкиПлагина()
	Возврат "УИ_ПлагинПарсераВстроенногоЯзыка";
КонецФункции

#КонецОбласти
