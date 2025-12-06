# Примеры использования

Здесь приведены примеры использования различных функций объекта YG в игровом проекте.

## Сохранение и загрузка данных пользователя

```gml
// Сохранение прогресса игрока
function save_player_progress() {
    YG.data.level = current_level;
    YG.data.score = player_score;
    YG.data.coins = player_coins;
    YG.data.unlocked_skins = unlocked_skins_array;
    
    YG.storage.data.send(
        function() { 
            show_debug_message("Прогресс успешно сохранен"); 
        },
        function() { 
            show_debug_message("Ошибка сохранения прогресса"); 
        }
    );
}

// Загрузка прогресса игрока при запуске игры
function load_player_progress() {
    YG.storage.data.get(
        function() { 
            // Восстанавливаем данные из сохранения
            if (variable_instance_exists(YG.data, "level")) {
                current_level = YG.data.level;
            }
            if (variable_instance_exists(YG.data, "score")) {
                player_score = YG.data.score;
            }
            if (variable_instance_exists(YG.data, "coins")) {
                player_coins = YG.data.coins;
            }
            if (variable_instance_exists(YG.data, "unlocked_skins")) {
                unlocked_skins_array = YG.data.unlocked_skins;
            }
            show_debug_message("Прогресс успешно загружен");
        },
        function() { 
            show_debug_message("Ошибка загрузки прогресса"); 
        }
    );
}
```

## Использование рекламы для вознаграждений

```gml
// Функция для получения дополнительных жизней за просмотр рекламы
function request_extra_lives() {
    if (YG.adv.reward.is_supported) {
        YG.adv.reward.show(
            function() { 
                // Игрок успешно посмотрел рекламу
                player_lives += 3; // Добавляем 3 жизни
                show_message("Вы получили 3 дополнительные жизни!");
            },
            function() { 
                // Игрок закрыл рекламу до окончания
                show_message("Посмотрите всю рекламу, чтобы получить награду в следующий раз!");
            }
        );
    } else {
        show_message("Реклама за вознаграждение временно недоступна");
    }
}

// Показ интерститиальной рекламы между уровнями
function show_level_complete_ad() {
    if (YG.adv.interstitial.is_showable()) {
        YG.adv.interstitial.show(
            function() { 
                // После закрытия рекламы переходим к следующему уровню
                next_level();
            }
        );
    } else {
        // Если реклама еще не доступна, просто переходим к следующему уровню
        next_level();
    }
}
```

## Управление аудио в зависимости от настроек

```gml
// Управление громкостью музыки и эффектов
function set_audio_volume(volume) {
    // Устанавливаем громкость через YG
    YG.audio.setVolume(volume);
    
    // Также применяем к внутренним аудио-ресурсам игры
    audio_sound_gain(global.music_track, volume, 0);
    audio_system_volume = volume;
}

// Получение текущей громкости при запуске игры
function init_audio() {
    var saved_volume = YG.audio.getVolume();
    set_audio_volume(saved_volume);
}
```

## Адаптация под тип устройства

```gml
// Адаптация интерфейса под тип устройства
function setup_device_controls() {
    if (YG.device_type == E_DEVICE_TYPE.MOBILE) {
        // Настройка сенсорных элементов управления
        show_touch_controls = true;
        enable_touch_gestures();
        
        // Адаптация UI под мобильные устройства
        scale_ui_elements(1.2);
    } else {
        // Настройка управления с мыши и клавиатуры
        show_touch_controls = false;
        disable_touch_gestures();
        
        // Стандартный размер UI для ПК
        scale_ui_elements(1.0);
    }
}
```

## Проверка состояния платформы

```gml
// Функция, вызываемая при изменении видимости игры
function on_visibility_change() {
    if (YG.platform.is_visible) {
        // Игра стала видимой - возобновляем игровой процесс
        if (game_was_paused) {
            resume_game();
            game_was_paused = false;
        }
    } else {
        // Игра свернута - ставим на паузу
        pause_game();
        game_was_paused = true;
    }
}

// Проверка, включены ли звуки на платформе
function check_platform_audio_state() {
    if (!YG.platform.is_audio_enabled) {
        // Звук отключен на платформе, возможно, стоит отключить аудио в игре
        mute_game_audio();
    } else {
        // Звук включен, восстанавливаем громкость
        unmute_game_audio();
    }
}
```

## Комплексный пример инициализации

```gml
// Инициализация YG-функций при запуске игры
function initialize_yandex_integration() {
    // Загружаем сохраненные данные пользователя
    load_player_progress();
    
    // Устанавливаем настройки аудио
    init_audio();
    
    // Настраиваем элементы управления в зависимости от устройства
    setup_device_controls();
    
    // Проверяем поддерживаемые функции рекламы
    if (!YG.adv.reward.is_supported) {
        // Отключаем кнопки, связанные с ревард-рекламой
        disable_reward_buttons();
    }
    
    if (!YG.adv.interstitial.is_supported) {
        // Изменяем логику показа рекламы
        adjust_ad_frequency();
    }
    
    show_debug_message("Yandex Games интеграция инициализирована");
}