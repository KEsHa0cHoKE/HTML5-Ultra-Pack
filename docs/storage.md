# Хранилище (Storage)

YG предоставляет функции для сохранения и загрузки данных пользователя на серверах Яндекса или в локальных файлах при тестировании.

## Data (Данные)

### `YG.storage.data.send([callback], [callbackFailed])`
Сохраняет данные data на сервер Яндекса, либо в локальные файлы при тесте.

Параметры:
- `_callback` (Function, опционально) - Коллбек при успешном получении сейвов
- `_callbackFailed` (Function, опционально) - Коллбек при неудаче

Пример:
```gml
YG.data.level = 5;
YG.data.score = 1000;
YG.storage.data.send(
    function() { show_debug_message("Данные успешно сохранены"); },
    function() { show_debug_message("Ошибка сохранения"); }
);
```

### `YG.storage.data.get([callback], [callbackFailed])`
Асинхронно получает данные сохранений data с сервера Яндекса. Результат запишется в структуру YG.data. Можно указать коллбек, выполнится при получении.

Параметры:
- `_callback` (Function, опционально) - Коллбек при успешном получении сейвов
- `_callbackFailed` (Function, опционально) - Коллбек при неудаче

Пример:
```gml
YG.storage.data.get(
    function() { show_debug_message("Данные успешно загружены: " + string(YG.data)); },
    function() { show_debug_message("Ошибка загрузки"); }
);
```

### `YG.storage.data.deleteAll()`
Отправляет на сервер Яндекса пустую структуру data, которая перезапишет собой сейвы, удалив их. Если билд тестовый то перезапишется файл.

Пример:
```gml
YG.storage.data.deleteAll();
```

## Stats (Статистика)

### `YG.storage.stats.send([callback], [callbackFailed])`
Сохраняет данные stats на сервер Яндекса, либо в локальные файлы при тесте.

Параметры:
- `_callback` (Function, опционально) - Коллбек при успешном получении сейвов
- `_callbackFailed` (Function, опционально) - Коллбек при неудаче

Пример:
```gml
YG.stats.games_played = 10;
YG.stats.best_score = 5000;
YG.storage.stats.send(
    function() { show_debug_message("Статистика успешно сохранена"); },
    function() { show_debug_message("Ошибка сохранения статистики"); }
);
```

### `YG.storage.stats.get([callback], [callbackFailed])`
Асинхронно получает данные сохранений stats с сервера Яндекса. Результат запишется в структуру YG.stats. Можно указать коллбек, выполнится при получении.

Параметры:
- `_callback` (Function, опционально) - Коллбек при успешном получении сейвов
- `_callbackFailed` (Function, опционально) - Коллбек при неудаче

Пример:
```gml
YG.storage.stats.get(
    function() { show_debug_message("Статистика успешно загружена: " + string(YG.stats)); },
    function() { show_debug_message("Ошибка загрузки статистики"); }
);
```

### `YG.storage.stats.deleteAll()`
Отправляет на сервер Яндекса пустую структуру stats, которая перезапишет собой сейвы, удалив их. Если билд тестовый то перезапишется файл.

Пример:
```gml
YG.storage.stats.deleteAll();