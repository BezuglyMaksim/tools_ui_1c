// Выводит текст, который пользователь может скопировать.
//
// Параметры:
//   Обработчик - ОписаниеОповещения - Описание процедуры, которая будет вызвана после завершения показа.
//       Возвращаемое значение аналогично ПоказатьВопросПользователю().
//   Текст     - Строка - Текст информации.
//   Заголовок - Строка - Необязательный. Заголовок окна. По умолчанию "Подробнее".
//
Процедура ПоказатьПодробнуюИнформацию(Обработчик, Текст,
		Заголовок = Неопределено) Экспорт
	НастройкиДиалога = Новый Структура;
	НастройкиДиалога.Вставить("ПредлагатьБольшеНеЗадаватьЭтотВопрос", Ложь);
	НастройкиДиалога.Вставить("Картинка", Неопределено);
	НастройкиДиалога.Вставить("ПоказыватьКартинку", Ложь);
	НастройкиДиалога.Вставить("МожноКопировать", Истина);
	НастройкиДиалога.Вставить("КнопкаПоУмолчанию", 0);
	НастройкиДиалога.Вставить("ВыделятьКнопкуПоУмолчанию", Ложь);
	НастройкиДиалога.Вставить("Заголовок", Заголовок);

	Если Не ЗначениеЗаполнено(НастройкиДиалога.Заголовок) Тогда
		НастройкиДиалога.Заголовок = НСтр("ru = 'Подробнее'");
	КонецЕсли;

	Кнопки = Новый СписокЗначений;
	Кнопки.Добавить(0, НСтр("ru = 'Закрыть'"));

	ПоказатьВопросПользователю(Обработчик, Текст, Кнопки, НастройкиДиалога);
КонецПроцедуры

// Показать форму вопроса.
//
// Параметры:
//   ОписаниеОповещенияОЗавершении - ОписаниеОповещения - описание процедуры, которая будет вызвана после закрытия окна
//                                                        вопроса со следующими параметрами:
//                                                          РезультатВопроса - Структура - структура со свойствами:
//                                                            Значение - результат выбора пользователя: значение
//                                                                       системного перечисления или значение,
//                                                                       связанное с нажатой кнопкой. В случае закрытия
//                                                                       диалога по истечении времени - значение
//                                                                       Таймаут.
//                                                            БольшеНеЗадаватьЭтотВопрос - Булево - результат выбора
//                                                                                                  пользователя в
//                                                                                                  одноименном флажке.
//                                                          ДополнительныеПараметры - Структура 
//   ТекстВопроса                  - Строка             - текст задаваемого вопроса. 
//   Кнопки                        - РежимДиалогаВопрос, СписокЗначений - может быть задан список значений, в котором:
//                                       Значение - содержит значение, связанное с 
//                                                  кнопкой и возвращаемое при выборе кнопки. В качестве значения может
//                                                  использоваться значение
//                                                  перечисления КодВозвратаДиалога, а также другие значения,
//                                                  поддерживающее XDTO-сериализацию.
//                                       Представление - задает текст кнопки.
//
//   ДополнительныеПараметры       - Структура          - см. СтандартныеПодсистемыКлиент.ПараметрыВопросаПользователю.
//
// Возвращаемое значение:
//   Результат выбора пользователя будет передан в метод, описанный параметром ОписаниеОповещенияОЗавершении. 
//
Процедура ПоказатьВопросПользователю(ОписаниеОповещенияОЗавершении,
		ТекстВопроса, Кнопки, ДополнительныеПараметры = Неопределено) Экспорт

	Если ДополнительныеПараметры <> Неопределено Тогда
		Параметры = ДополнительныеПараметры;
	Иначе
		Параметры = Новый Структура;
	КонецЕсли;

	УИ_ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(Параметры, ПараметрыВопросаПользователю(), Ложь);

	КнопкиПараметр = Кнопки;

	Если ТипЗнч(Параметры.КнопкаПоУмолчанию) = Тип("КодВозвратаДиалога") Тогда
	//@skip-warning
		Параметры.КнопкаПоУмолчанию = КодВозвратаДиалогаВСтроку(Параметры.КнопкаПоУмолчанию);
	КонецЕсли;

	Если ТипЗнч(Параметры.КнопкаТаймаута) = Тип("КодВозвратаДиалога") Тогда
		Параметры.КнопкаТаймаута = КодВозвратаДиалогаВСтроку(Параметры.КнопкаТаймаута);
	КонецЕсли;

	Параметры.Вставить("Кнопки", КнопкиПараметр);
	Параметры.Вставить("ТекстСообщения", ТекстВопроса);

	ПоказатьВопрос(ОписаниеОповещенияОЗавершении, ТекстВопроса, КнопкиПараметр, , Параметры.КнопкаПоУмолчанию, "", Параметры.КнопкаТаймаута);

КонецПроцедуры

// Возвращает новую структуру дополнительных параметров для процедуры ПоказатьВопросПользователю.
//
// Возвращаемое значение:
//  Структура   - структура со свойствами:
//    * КнопкаПоУмолчанию             - Произвольный - определяет кнопку по умолчанию по типу кнопки или по связанному
//                                                     с ней значению.
//    * Таймаут                       - Число        - интервал времени в секундах до автоматического закрытия окна
//                                                     вопроса.
//    * КнопкаТаймаута                - Произвольный - кнопка (по типу кнопки или по связанному с ней значению), 
//                                                     на которой отображается количество секунд, оставшихся до
//                                                     истечения таймаута.
//    * Заголовок                     - Строка       - заголовок вопроса. 
//    * ПредлагатьБольшеНеЗадаватьЭтотВопрос - Булево - если Истина, то в окне вопроса будет доступен одноименный флажок.
//    * БольшеНеЗадаватьЭтотВопрос    - Булево       - принимает значение, выбранное пользователем в соответствующем
//                                                     флажке.
//    * БлокироватьВесьИнтерфейс      - Булево       - если Истина, форма вопроса открывается, блокируя работу всех
//                                                     остальных открытых окон, включая главное окно.
//    * Картинка                      - Картинка     - картинка, выводимая в окне вопроса.
//
Функция ПараметрыВопросаПользователю() Экспорт

	Параметры = Новый Структура;
	Параметры.Вставить("КнопкаПоУмолчанию", Неопределено);
	Параметры.Вставить("Таймаут", 0);
	Параметры.Вставить("КнопкаТаймаута", Неопределено);
	Параметры.Вставить("Заголовок", КлиентскоеПриложение.ПолучитьЗаголовок());
	Параметры.Вставить("ПредлагатьБольшеНеЗадаватьЭтотВопрос", Истина);
	Параметры.Вставить("БольшеНеЗадаватьЭтотВопрос", Ложь);
	Параметры.Вставить("БлокироватьВесьИнтерфейс", Ложь);
	Параметры.Вставить("Картинка", БиблиотекаКартинок.Вопрос32);
	Возврат Параметры;

КонецФункции

// Возвращает строковое представление значения типа КодВозвратаДиалога.
Функция КодВозвратаДиалогаВСтроку(Значение)

	Результат = "КодВозвратаДиалога." + Строка(Значение);

	Если Значение = КодВозвратаДиалога.Да Тогда
		Результат = "КодВозвратаДиалога.Да";
	ИначеЕсли Значение = КодВозвратаДиалога.Нет Тогда
		Результат = "КодВозвратаДиалога.Нет";
	ИначеЕсли Значение = КодВозвратаДиалога.ОК Тогда
		Результат = "КодВозвратаДиалога.ОК";
	ИначеЕсли Значение = КодВозвратаДиалога.Отмена Тогда
		Результат = "КодВозвратаДиалога.Отмена";
	ИначеЕсли Значение = КодВозвратаДиалога.Повторить Тогда
		Результат = "КодВозвратаДиалога.Повторить";
	ИначеЕсли Значение = КодВозвратаДиалога.Прервать Тогда
		Результат = "КодВозвратаДиалога.Прервать";
	ИначеЕсли Значение = КодВозвратаДиалога.Пропустить Тогда
		Результат = "КодВозвратаДиалога.Пропустить";
	КонецЕсли;

	Возврат Результат;

КонецФункции

#Область Алгоритмы

Функция ВыполнитьАлгоритм(АлгоритмСсылка, ВходящиеПараметры = Неопределено,
		ОшибкаВыполнения = Ложь, СообщениеОбОшибке = "") Экспорт
	Возврат УИ_АлгоритмыКлиентСервер.ВыполнитьАлгоритм(АлгоритмСсылка, ВходящиеПараметры, ОшибкаВыполнения, СообщениеОбОшибке)
КонецФункции

#КонецОбласти

#Область Отладка

Процедура ОткрытьКонсольОтладки(ТипОбъектаОтладки, ДанныеДляОтладки) Экспорт
	Если ВРег(ТипОбъектаОтладки) = "ЗАПРОС" Тогда
		ИмяФормыКонсоли = "Обработка.УИ_КонсольЗапросов.Форма";
	ИначеЕсли ВРег(ТипОбъектаОтладки) = "СХЕМАКОМПОНОВКИДАННЫХ" Тогда
		ИмяФормыКонсоли = "Отчет.УИ_КонсольОтчетов.Форма";
	ИначеЕсли ВРег(ТипОбъектаОтладки)="ОБЪЕКТБАЗЫДАННЫХ" Тогда 
		ИмяФормыКонсоли = "Обработка.УИ_РедакторРеквизитовОбъекта.Форма";
	Иначе
		Возврат;
	КонецЕсли;

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ДанныеОтладки", ДанныеДляОтладки);

	ОткрытьФорму(ИмяФормыКонсоли, ПараметрыФормы);

КонецПроцедуры

#КонецОбласти