��    *      l  ;   �      �  B   �  !  �  �    9   �  M   9     �  ,   �  ,   �  ,   �  '   *	  -   R	      �	  (   �	  (   �	     �	     
     3
  �   @
  e   8  :   �    �  �  �  �  �     e     z  *   �  1   �  &   �            "   3  9   V  I   �  �   �     x     �     �     �     �     �     �  �  �  f   �  �  !  X  �  a   Q  m   �  7   !  i   Y  \   �  i      L   �  j   �  >   B  M   �  N   �  1      1   P      �     �   �   �"  U   =#    �#  \  �%  �  �(  '   u+     �+  O   �+  E   ,  W   M,     �,  0   �,  ?   �,  h   %-  �   �-  �   .  "   /  )   6/      `/  #   �/     �/  ,   �/     �/           "   #               '   
                                             (                           &                 )   	       !      %           $                                           *         -V, --version               output version information and exit
   -d, --domain=TEXTDOMAIN   retrieve translated message from TEXTDOMAIN
  -e                        enable expansion of some escape sequences
  -E                        (ignored for compatibility)
  -h, --help                display this help and exit
  -V, --version             display version information and exit
  [TEXTDOMAIN]              retrieve translated message from TEXTDOMAIN
  MSGID MSGID-PLURAL        translate MSGID (singular) / MSGID-PLURAL (plural)
  COUNT                     choose singular/plural form based on this value
   -d, --domain=TEXTDOMAIN   retrieve translated messages from TEXTDOMAIN
  -e                        enable expansion of some escape sequences
  -E                        (ignored for compatibility)
  -h, --help                display this help and exit
  -n                        suppress trailing newline
  -V, --version             display version information and exit
  [TEXTDOMAIN] MSGID        retrieve translated message corresponding
                            to MSGID from TEXTDOMAIN
   -h, --help                  display this help and exit
   -v, --variables             output the variables occurring in SHELL-FORMAT
 %s: invalid option -- '%c'
 %s: option '%c%s' doesn't allow an argument
 %s: option '%s' is ambiguous; possibilities: %s: option '--%s' doesn't allow an argument
 %s: option '--%s' requires an argument
 %s: option '-W %s' doesn't allow an argument
 %s: option '-W %s' is ambiguous
 %s: option '-W %s' requires an argument
 %s: option requires an argument -- '%c'
 %s: unrecognized option '%c%s'
 %s: unrecognized option '--%s'
 Bruno Haible Copyright (C) %s Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
 Display native language translation of a textual message whose grammatical
form depends on a number.
 Display native language translation of a textual message.
 If the TEXTDOMAIN parameter is not given, the domain is determined from the
environment variable TEXTDOMAIN.  If the message catalog is not found in the
regular directory, another location can be specified with the environment
variable TEXTDOMAINDIR.
Standard search directory: %s
 If the TEXTDOMAIN parameter is not given, the domain is determined from the
environment variable TEXTDOMAIN.  If the message catalog is not found in the
regular directory, another location can be specified with the environment
variable TEXTDOMAINDIR.
When used with the -s option the program behaves like the 'echo' command.
But it does not simply copy its arguments to stdout.  Instead those messages
found in the selected catalog are translated.
Standard search directory: %s
 In normal operation mode, standard input is copied to standard output,
with references to environment variables of the form $VARIABLE or ${VARIABLE}
being replaced with the corresponding values.  If a SHELL-FORMAT is given,
only those environment variables that are referenced in SHELL-FORMAT are
substituted; otherwise all environment variables references occurring in
standard input are substituted.
 Informative output:
 Operation mode:
 Report bugs to <bug-gnu-gettext@gnu.org>.
 Substitutes the values of environment variables.
 Try '%s --help' for more information.
 Ulrich Drepper Unknown system error Usage: %s [OPTION] [SHELL-FORMAT]
 Usage: %s [OPTION] [TEXTDOMAIN] MSGID MSGID-PLURAL COUNT
 Usage: %s [OPTION] [[TEXTDOMAIN] MSGID]
or:    %s [OPTION] -s [MSGID]...
 When --variables is used, standard input is ignored, and the output consists
of the environment variables that are referenced in SHELL-FORMAT, one per line.
 Written by %s.
 error while reading "%s" memory exhausted missing arguments standard input too many arguments write error Project-Id-Version: gettext-runtime 0.18.2
Report-Msgid-Bugs-To: bug-gnu-gettext@gnu.org
POT-Creation-Date: 2014-12-24 16:27+0900
PO-Revision-Date: 2013-02-26 22:34+0200
Last-Translator: Yuri Chornoivan <yurchor@ukr.net>
Language-Team: Ukrainian <translation-team-uk@lists.sourceforge.net>
Language: uk
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Generator: Lokalize 1.5
Plural-Forms: nplurals=1; plural=0;
   -V, --version               вивести інформацію про версію та вийти
   -d, --domain=ДОМЕН_ТЕКСТУ використовувати перекладені повідомлення з
                            вказаного домену ДОМЕН_ТЕКСТУ
  -e                        дозволити використання деяких escape-послідовностей
  -E                        (ігнорується, використовується для сумісності)
  -h, --help                показати цю довідку та вийти
  -V, --version             відобразити інформацію про версію та вийти
  [ДОМЕН_ТЕКСТУ]            знайти переклад у вказаному домені ДОМЕН_ТЕКСТУ
  MSGID MSGID-PLURAL        перекласти MSGID (однина) / MSGID-PLURAL (множина)
  ЧИСЛО                     вибрати однину/множину на основі цього значення
   -d, --domain=ДОМЕН_ТЕКСТУ використовувати перекладені повідомлення з
                            домену ДОМЕН_ТЕКСТУ
  -e                        дозволити використання деяких escape-послідовностей
  -E                        (ігнорується, використовується для сумісності)
  -h, --help                показати цю довідку та вийти
  -n                        не виводити наприкінці символ переведення рядка
  -V, --version             відобразити інформацію про версію та вийти
  [ДОМЕН_ТЕКСТУ] MSGID      знайти переклад повідомлення MSGID у ДОМЕН_ТЕКСТУ
   -h, --help                  вивести довідку та завершити роботу
   -v, --variables             виводити змінні, що зустрічаються у SHELL-FORMAT
 %s: некоректний параметр — «%c»
 %s: додавання аргументів до параметра «%c%s» не передбачено
 %s: параметр «%s» не є однозначним. Можливі варіанти: %s: додавання аргументів до параметра «--%s» не передбачено
 %s: до параметра «--%s» слід додати аргумент
 %s: додавання аргументів до параметра «-W %s» не передбачено
 %s: параметр «-W %s» не є однозначним
 %s: до параметра «-W %s» слід додати аргумент
 %s: до параметра слід додати аргумент — «%c»
 %s: невідомий параметр «%c%s»
 %s: невідомий параметр «--%s»
 Bruno Haible Авторські права належать Free Software Foundation, Inc., %s
Умови ліцензування викладено у GPLv3+: GNU GPL версії 3 або новішій, <http://gnuorg/licenses/gpl.html>
Це вільне програмне забезпечення: ви можете вільно змінювати і поширювати його.
Вам не надається ЖОДНИХ ГАРАНТІЙ, окрім гарантій передбачених законодавством.
 Відображає переклад текстового повідомлення, граматична форма якого залежить
від числа.
 Відображає переклад текстового повідомлення.
 Якщо параметр ДОМЕН_ТЕКСТУ не вказаний, використовується домен, визначений у
змінній середовища TEXTDOMAIN. Якщо файл з перекладеними повідомленнями
відсутній у стандартному каталозі, можна вказати інший каталог за допомогою
змінної середовища TEXTDOMAINDIR.
Стандартний каталог пошуку: %s
 Якщо не вказаний параметр ДОМЕН_ТЕКСТУ, використовується домен, встановлений
у змінній середовища TEXTDOMAIN. Якщо файл з перекладеними повідомленнями
відсутній у типовому каталозі, можна вказати інший каталог за допомогою
змінної середовища TEXTDOMAINDIR.
При використанні з ключем -s, поведінка програми схожа на поведінку програми
«echo». Але замість простого копіювання аргументів у стандартний вивід,
виводяться їх переклади з вказаного домену.
Стандартний каталог пошуку: %s
 У звичайному режимі роботи, стандартний ввід копіюється на стандартний вивід,
де посилання на змінні середовища у формі $VARIABLE або ${VARIABLE}, 
замінюються відповідними значеннями. Якщо вказано SHELL-FORMAT,
будуть замінюватись лише змінні, що вказані у SHELL-FORMAT; у іншому
випадку будуть замінюватись усі змінні середовища, що зустрічаються у
стандартному вводі.
 Інформативний вивід:
 Режим роботи:
 Про помилки повідомляйте на <bug-gnu-gettext@gnu.org>.
 Замінює значення змінних середовища.
 Віддайте команду «%s --help», щоб дізнатися більше.
 Ulrich Drepper Невідома системна помилка Використання: %s [ПАРАМЕТР] [SHELL-FORMAT]
 Використання: %s [ПАРАМЕТР] [ДОМЕН_ТЕКСТУ] MSGID MSGID-PLURAL ЧИСЛО
 Використання: %s [ПАРАМЕТР] [[ДОМЕН_ТЕКСТУ] MSGID]
або:          %s [ПАРАМЕТР] -s [MSGID]...
 При використанні --variables, стандартний ввід ігнорується, а вивід
складається зі змінних середовища, які вказані у SHELL-FORMAT, по одній на рядок.
 Автор програми - %s.
 помилка при читанні "%s" пам'ять вичерпано відсутні аргументи стандартний ввід надто багато аргументів помилка запису 