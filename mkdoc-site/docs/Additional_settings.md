# Настройки HTML5 цели

Эти настройки производятся единожды, влияя на дальнейшую работу с HTML5 целью в GameMaker

## **[Настройка](https://manual.gamemaker.io/beta/en/Setting_Up_And_Version_Information/Platform_Preferences/HTML5.htm)** HTML5 Preferences:

> Эти настройки позволяют избежать ошибок при тестировании сборок в браузере, а также уменьшают размер билда

1. Перейдите в `Preferences` нажатием клавиш `Ctrl + Shift + P`
2. Перейдите в `Platform Settings - HTML5`
3. Снимите галочку с `Obfuscate`
4. Убедитесь, что галочка напротив `Remove Unused Functions` установлена

***

## **Настройка** возможности тестировать сборки в браузере

> Эти настройки позволяют тестировать сборки в браузере без необходимости загружать их на хостинг

1. Нажмите сочетание клавиш `win+r`, введите там `cmd.exe` и нажмите `enter`
2. Введите в командной строке `ipconfig` и нажмите `enter`
3. Скопируйте адрес, который находится в строке `IPv4-адрес`
4. Перейдите обратно в `Preferences` и вставьте адрес в поле `Default Web Server Adress`. Пример того что должно получиться: `http://192.168.30.85`

!!! tip "Совет"
    После этих настроек вы не только сможете тестировать сборки в браузере на устройстве с которого вы их запускаете, но и на других устройствах в той же сети. Например открыв ссылку на сборку в браузере телефона

***

## **Настройка** макета сборки `index.html` файла

> Эти настройки позволят избежать ручного редактирования `index.html` файла для избежания нежелательного поведения при лонг тапах на некоторых устройствах и браузерах *(обязательно для прохождения модерации на Yandex Games)*

1. Нажмите сочетание клавиш `win+r`, введите там `%ProgramData%` и нажмите `enter`
2. Откройте файл по относительному пути `.\GameMakerStudio2\Cache\runtimes\runtime-2024.8.1.218\html5\index.html`
3. Найдите тег `<style>` и добавьте внутрь следующий блок кода:
```css
.noselect {
    -webkit-touch-callout: none; /* IOS Safari */
    -webkit-user-select: none; /* Safari */
    -khtml-user-select: none; /* Konqueror HTML */
    -moz-user-select: none; /* Old versions of FireFox */
    -ms-user-select: none; /* Internet Explorer/Edge */
    user-select: none; /* Non-prefixed version, currently supported by Chrome, Edge, Opera and FireFox */
}
```
4. Найдите тег `<body>` и оберните код внутри в тег `<div>` с классом `noselect`:
```html
<body>
    <div class="noselect"> <!-- Добавляем эту строку -->
        <!-- Код из <body> -->
    </div> <!-- И эту строку -->
</body>
```

!!! tip "Совет"
    При смене версии рантайма, вам нужно будет проделать это действие с `index.html` из папки с новым рантаймом

***

## **Настройка** `web_dyn_tex` расширения

> Эти настройки позволят **ЗНАЧИТЕЛЬНО** сократить время загрузки игры, которое критически важно для платформ с HTML5 играми

1. Скачайте и распакуйте [Neko VM](https://nekovm.org/download/) *(если не уверены куда тыкать - выбирайте `Windows x86 64-bit binaries`)* в постоянную папку, например по пути `C:\neko\`
2. Скачайте и запустите установщик [ImageMagick](https://imagemagick.org/script/download.php#windows) *(если не уверены куда тыкать - выбирайте самую верхнюю)*
3. Добавьте пути к папкам с `Neko VM` и `ImageMagick` в [PATH](https://stackoverflow.com/questions/44272416/add-a-folder-to-the-path-environment-variable-in-windows-10-with-screenshots)
4. Перезагрузите пк *(обязательно)*

### Настройки в проекте

1. В проекте, который уже содержит в себе `HTML5 Ultra Pack` откройте extension `web_dyn_tex`
2. Установите галочку напротив `Enable post-build script`
3. `Fallback textures` рекомендую установить на `Lossy WEBP`
4. Если сборка тестового билда успешно завершается значит всё сделано верно