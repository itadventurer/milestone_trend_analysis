# Milestone trend analysis

## Meilensteinverlaufsanalyse
Im Folgenden soll ein Tool zur Meilensteinverlaufsanalyse und Earned-Value-Management für Projektleiter und -manager beschrieben werden. Die zentralen Fragen sind: „Wann wird das Projekt tatsächlich fertig sein?” und „Was sind die tatsächlichen Kosten des Projekts?”.

Es bietet dem Nutzer Möglichkeiten zur Projekterstellung und --Verwaltung. Projekte besitzen neben Daten wie dem Startzeitpunkt und dem möglichen Enddatum auch Meilensteine, die verwaltet werden können. Die historischen, aktuellen und prognostizierten Meilensteine werden zunächst in tabellarischer Form und optional in grafischer Form angezeigt. Für Übersichten von Meilensteinen oder Projekten ist ein Export als PDF-Datei möglich, um zum Beispiel den Manager bei einer Präsentation oder einem Kundengespräch zu unterstützen. 

Eine weitere Produktfunktion ist die Earned-Value-Analyse. Es existieren in Meilensteinen und Projekten dazu Möglichkeiten, ähnlich derer für den Fertigstellungstermin. So kann man ebenfalls Budgets eintragen, die dazu genutzt werden um ein wahrscheinliches maximales Budget zu berechnen. 


## Install

Clone the Git-repository and run the following commands:

    $ bundle install
    $ rake db:migrate

Then you can run a server via

    $ rails server

For the generation of the png-files you need the `rsvg-convert`-command (`librsvg`)

## Credits
* Joris Rau
* Marcus Hubrich
* Christopher Lienemann
* Alexander Kropp
* [Anatolij Zelenin](http://azapps.de) (me)

## License

(MIT License)

Copyright (c) 2012-2013 Joris Rau, Marcus Hubrich, Christopher Lienemann, Alexander Kropp, Anatoly Zelenin

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
