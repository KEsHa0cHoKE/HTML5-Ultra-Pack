# Платформа

YG предоставляет информацию о текущей платформе и состоянии приложения.

## Свойства

- `YG.platform.id` - ID платформы (например, PG_PLATFORM_YANDEX и другие)
- `YG.platform.is_audio_enabled` - Булевое значение, включен ли звук на платформе
- `YG.platform.is_paused` - Булевое значение, приостановлена ли игра
- `YG.platform.is_visible` - Булевое значение, видна ли игра пользователю

## Типы устройств

YG определяет тип устройства автоматически:

- `YG.device_type` может быть `E_DEVICE_TYPE.PC` или `E_DEVICE_TYPE.MOBILE`

Примеры использования:
```gml
// Проверка типа устройства
if (YG.device_type == E_DEVICE_TYPE.MOBILE) {
    // Используем сенсорные жесты вместо мыши
    show_mobile_controls();
} else {
    // Показываем подсказки для мыши и клавиатуры
    show_desktop_hints();
}

// Проверка, видима ли игра пользователю
if (!YG.platform.is_visible) {
    // Приложение свернуто, можно приостановить игровой процесс
    game_paused = true;
} else {
    game_paused = false;
}

// Проверка состояния аудио на платформе
if (!YG.platform.is_audio_enabled) {
    // Звук отключен на платформе, возможно стоит отключить свои аудиоэффекты
    mute_audio_effects();
}
```

## Поддерживаемые платформы

YG поддерживает следующие платформы:
- Yandex Games (`PG_PLATFORM_YANDEX`)
- PlayGama (`PG_PLATFORM_PLAYGAMA`)
- VK (`PG_PLATFORM_VK`)
- OK (`PG_PLATFORM_OK`)
- Facebook (`PG_PLATFORM_FACEBOOK`)
- Crazy Games (`PG_PLATFORM_CRAZY_GAMES`)
- Game Distribution (`PG_PLATFORM_GAME_DISTRIBUTION`)
- PlayDeck (`PG_PLATFORM_PLAYDECK`)
- Telegram (`PG_PLATFORM_TELEGRAM`)
- Y8 (`PG_PLATFORM_Y8`)
- Lagged (`PG_PLATFORM_LAGGED`)
- MSN (`PG_PLATFORM_MSN`)
- Poki (`PG_PLATFORM_POKI`)
- QA Tool (`PG_PLATFORM_QA_TOOL`)
- Discord (`PG_PLATFORM_DISCORD`)
- GamePush (`PG_PLATFORM_GAMEPUSH`)
- BitQuest (`PG_PLATFORM_BITQUEST`)
- Huawei (`PG_PLATFORM_HUAWEI`)
- Jio Games (`PG_PLATFORM_JIO_GAMES`)
- Reddit (`PG_PLATFORM_REDDIT`)
- YouTube (`PG_PLATFORM_YOUTUBE`)
- Mock (`PG_PLATFORM_MOCK`)