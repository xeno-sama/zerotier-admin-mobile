// Функция для транслитерации кириллицы в латиницу
import 'package:intl/intl.dart';

String transliterate(String input) {
  const translitMap = <String, String>{
    'а': 'a', 'б': 'b', 'в': 'v', 'г': 'g', 'д': 'd',
    'е': 'e', 'ё': 'yo', 'ж': 'zh', 'з': 'z', 'и': 'i',
    'й': 'y', 'к': 'k', 'л': 'l', 'м': 'm', 'н': 'n',
    'о': 'o', 'п': 'p', 'р': 'r', 'с': 's', 'т': 't',
    'у': 'u', 'ф': 'f', 'х': 'kh', 'ц': 'ts', 'ч': 'ch',
    'ш': 'sh', 'щ': 'shch', 'ъ': '', 'ы': 'y', 'ь': '',
    'э': 'e', 'ю': 'yu', 'я': 'ya',
    // Заглавные буквы
    'А': 'A', 'Б': 'B', 'В': 'V', 'Г': 'G', 'Д': 'D',
    'Е': 'E', 'Ё': 'Yo', 'Ж': 'Zh', 'З': 'Z', 'И': 'I',
    'Й': 'Y', 'К': 'K', 'Л': 'L', 'М': 'M', 'Н': 'N',
    'О': 'O', 'П': 'P', 'Р': 'R', 'С': 'S', 'Т': 'T',
    'У': 'U', 'Ф': 'F', 'Х': 'Kh', 'Ц': 'Ts', 'Ч': 'Ch',
    'Ш': 'Sh', 'Щ': 'Shch', 'Ъ': '', 'Ы': 'Y', 'Ь': '',
    'Э': 'E', 'Ю': 'Yu', 'Я': 'Ya',
  };

  return input.split('').map((char) => translitMap[char] ?? char).join();
}

String formatWord(int number, String one, String few, String many) {
  var n = number % 100;
  if (n >= 11 && n <= 14) {
    return many;
  }
  n = number % 10;
  if (n == 1) {
    return one;
  }
  if (n >= 2 && n <= 4) {
    return few;
  }
  return many;
}

String formatLastSeen(String lastSeen, String languageCode) {
  final lastSeenDateTime = DateTime.parse(lastSeen);
  final now = DateTime.now();

  final difference = now.difference(lastSeenDateTime);

  // Устанавливаем локаль по умолчанию для Intl
  // Intl.defaultLocale = languageCode;

  if (difference.inMinutes < 60) {
    final minutes = difference.inMinutes;
    if (languageCode == 'ru') {
      return Intl.plural(
        minutes,
        zero: Intl.message('только что', name: 'justNow'),
        one: '$minutes ${Intl.message('минуту назад', name: 'minuteAgo')}',
        few: '$minutes ${Intl.message('минуты назад', name: 'minutesAgo')}',
        many: '$minutes ${Intl.message('минут назад', name: 'minutes_Ago')}',
        other: '$minutes ${Intl.message('минут назад', name: 'minutesAgo')}',
      );
    } else {
      return Intl.plural(
        minutes,
        zero: Intl.message('just now', name: 'justNow'),
        one: '$minutes ${Intl.message('minute ago', name: 'minuteAgo')}',
        few: '$minutes ${Intl.message('minutes ago', name: 'minutesAgo')}',
        many: '$minutes ${Intl.message('minutes ago', name: 'minutesAgo')}',
        other: '$minutes ${Intl.message('minutes ago', name: 'minutesAgo')}',
      );
    }
  } else if (difference.inHours < 24) {
    final hours = difference.inHours;
    if (languageCode == 'ru') {
      return Intl.plural(
        hours,
        zero: Intl.message('только что', name: 'justNow'),
        one: '$hours ${Intl.message('час назад', name: 'hourAgo')}',
        few: '$hours ${Intl.message('часа назад', name: 'hoursAgo')}',
        many: '$hours ${Intl.message('часов назад', name: 'hoursAgo')}',
        other: '$hours ${Intl.message('часов назад', name: 'hoursAgo')}',
      );
    } else {
      return Intl.plural(
        hours,
        zero: Intl.message('just now', name: 'justNow'),
        one: '$hours ${Intl.message('hour ago', name: 'hourAgo')}',
        few: '$hours ${Intl.message('hours ago', name: 'hoursAgo')}',
        many: '$hours ${Intl.message('hours ago', name: 'hoursAgo')}',
        other: '$hours ${Intl.message('hours ago', name: 'hoursAgo')}',
      );
    }
  } else if (difference.inDays < 7) {
    final days = difference.inDays;
    if (languageCode == 'ru') {
      return Intl.plural(
        days,
        zero: Intl.message('только что', name: 'justNow'),
        one: '$days ${Intl.message('день назад', name: 'dayAgo')}',
        two: '$days ${Intl.message('дня назад', name: 'fewDaysAgo')}',
        few: '$days ${Intl.message('дня назад', name: 'fewDaysAgo')}',
        many: '$days ${Intl.message('дней назад', name: 'daysAgo')}',
        other: '$days ${Intl.message('дней назад', name: 'daysAgo')}',
      );
    } else {
      return Intl.plural(
        days,
        zero: Intl.message('just now', name: 'justNow'),
        one: '$days ${Intl.message('day ago', name: 'dayAgo')}',
        few: '$days ${Intl.message('days ago', name: 'daysAgo')}',
        many: '$days ${Intl.message('days ago', name: 'daysAgo')}',
        other: '$days ${Intl.message('days ago', name: 'daysAgo')}',
      );
    }
  } else {
    return DateFormat.yMMMd(languageCode).format(lastSeenDateTime);
  }
}
