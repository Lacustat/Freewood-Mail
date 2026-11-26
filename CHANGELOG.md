# Freewood-Mail – Änderungen und Details · Changelog and details

Die vollständige bisherige Beschreibung mit allen Versionseinträgen (vorher README.md). The complete previous description with all version entries (formerly README.md). Kurzfassung · Summary: [README.md](README.md).

**Deutsch & English · German & English.** Autor · Author: Lacustat. Version 0.3.3 · Interface 16001 (World of Warcraft: Forever).

![Mail](https://github.com/Lacustat/Freewood-OctoWoW-Bilder/blob/main/mail.jpg)

## Inhalt · Contents
- [Deutsch](#deutsch)
- [English](#english)
- [Tastenbelegung · Key bindings](#tastenbelegung--key-bindings)

## Deutsch

### Was ist das?
Ein eigenes Briefkasten-Fenster (optional, standardmäßig aus): alles oder Ausgewähltes sicher öffnen, letzte Empfänger, Mailinglisten mit Automatik, mehrere Items pro Versand, Gold-Überschuss, Nachnahme, Archiv und Rückversand.

### Funktionen
- Einschalten: Einstellungen > Briefkasten > „Normalen Briefkasten ersetzen“ oder `/fwmail on` (`/fwmail off` schaltet zurück). Das normale Fenster bleibt unsichtbar offen, damit Brett-Aufträge weiter funktionieren.
- Posteingang: „Alles öffnen“ oder „Nur Ausgewählte“. Ein Taschenplatz bleibt immer frei. Geleerte Briefe werden entfernt und vorher im Archiv gesichert (suchbar, Aufbewahrungsdauer einstellbar).
- Nachnahme-Briefe werden nie automatisch genommen („Zahlen und nehmen“ mit zweitem Klick). „Löschen“ löscht sie nie, sondern schickt sie an den Absender zurück.
- Senden: Empfänger mit Liste der letzten, Betreff, Text, Items, Gold, Nachnahme; mehrere Items werden als mehrere Briefe nacheinander gesendet, das Tempo passt sich dem Server an.
- Mailinglisten: pro Charakter Name und Items, „automatisch beim Öffnen senden“ und „Gold über … senden“. Für Brett-Aufträge reservierte Items werden nicht verschickt.
- Brett-Briefe: Mit Creator und Brett wird der Brief eines Brett-Auftrags im Freewood-Briefkasten vorbereitet und automatisch gesendet, sobald alles stimmt (abschaltbar).

### Abhängigkeiten
- Benötigt: `Freewood-Core`
- Optional: `Freewood-Creator`, `Freewood-Brett`

### Befehle
- `/fwmail`: Fenster ein- oder ausblenden (bei offenem Briefkasten)
- `/fwmail on` / `/fwmail off`: eigenen Briefkasten ein- oder ausschalten
- `/fwmail archive`: Archiv öffnen

### Installation
Den Ordner `Freewood-Mail` nach `World of Warcraft\_forever_\Interface\AddOns\` kopieren. Neue Dateien lädt das Spiel erst nach einem kompletten Neustart; ein `/reload` genügt nur, wenn sich bestehende Dateien geändert haben. Fehler sichtbar machen: `/console scriptErrors 1`, danach `/reload`.

### Hinweise

- Aus der OctoWoW-Version übernommen (nur Code). Im Spiel noch nicht geprüft; die Anbindung an Brett ist noch nicht vollständig (Brett hat in Forever noch den älteren Stand).
- Mail ersetzt keine Blizzard-Funktionen mehr (`DeleteInboxItem`, `UseContainerItem`): Das verursachte auf Forever „Freewood-Mail wurde blockiert“ beim Benutzen von Items. Dadurch gibt es keinen Rechtsklick-Anhängen mehr (Items per Ziehen oder „Items hinzufügen“) und keinen Schutz vor dem Löschen von Nachnahme-Briefen im Blizzard-Fenster. Unser eigenes Fenster schützt Nachnahme-Briefe weiterhin.
- 0.3.3: Mailinglisten und Senden finden jetzt auch Items in der Reagenzientasche (Tasche 5: Kräuter, Erze, Öle fehlten vorher und standen als „nicht in den Taschen“ da). Neu im Auswahlfenster: ein Ablege-Feld oben, ein Item aus den Taschen hineinziehen fügt es hinzu (Mailingliste: das Item; Senden: der erste freie Stapel). Im Spiel ungeprüft, ob Forever die Reagenzientasche hat.
- 0.3.2: Behoben: „Alle nehmen“ und „Alle öffnen“ ließen bei mehreren gleichen Stapeln im Brief (z. B. 4x „Silberblatt x20“) den Rest liegen, weil der Brief nach jedem Nehmen gleich aussah und nach 3 Versuchen aufgegeben wurde. Die Versuche zählen jetzt je Zustand (Anzahl Anhänge und erster Platz).
- 0.3.1: Behoben: Im normalen Design zeigte der Briefkasten beim ersten Öffnen die Grafik von „Legion der Affen“ dahinter, bis man auf Legion und zurück stellte. Frisch angelegte Teile werden jetzt sofort passend ein- oder ausgeblendet.
- 0.3.0: Detailansicht zeigt alle Anhänge als Raster wie im Blizzard-Fenster (bis 16, Menge, Qualitätsrahmen, Tooltip je Item). Klick auf ein Symbol nimmt genau dieses Item (nicht bei Nachnahme); der Knopf „Alle nehmen (n)“ nimmt alles aus diesem Brief nacheinander. Behoben: Lücken bei den Anhang-Plätzen (nach dem Nehmen aus der Mitte) wurden nicht erkannt; jetzt werden alle Plätze gelesen und gezielt genommen. Test `texlua tests/attach_test.lua`. Im Spiel ungeprüft.
- 0.2.2: Postfach: Schließen ist jetzt ein großes „X“ mittig im Ring (keine Knopfgrafik); Holzknöpfe zentriert, schlanke Planken (Core 0.46.1).
- 0.2.1: Postfach: Holzknöpfe und Holz-Rollbalken aus dem Core (folgen dem Postfach-Design: Legion = immer, Normal = nie, Automatisch = Gesamtdesign); der Hinweis unten läuft nicht mehr unter das Pergament. Braucht Freewood-Core 0.46.0. Ungeprüft im Spiel.
- 0.2.0: Neues Postfach-Design „Legion der Affen“ (Datei `MailSkin.lua`, Bilder in `Media/Legion`): fester Holzrahmen (1100×733), Lederhintergrund, die Reiter Postfach/Senden/Listen als Dropdown oben im Rahmen, Pergament hinter dem Lesefenster, Zeilen mit goldener (geöffnet) und roter (Maus darüber) Leiste, roter Schließen-Knopf im Ring. Einstellung „Postfach-Design“: Automatisch (folgt dem Gesamtdesign „Legion der Affen“), Normal oder Legion der Affen. Umkehrbar, das normale Fenster bleibt unverändert. Ungeprüft im Spiel (Laden der Bilder, Lage von Dropdown und Schließen-Knopf, Lesbarkeit auf dem Pergament). Knöpfe und Rollbalken sind noch nicht im neuen Stil.
- 0.1.16: Die Nachnahme-Prüfung ist jetzt standardmäßig aus, die Einstellung steht einmalig auf „aus“ (Blizzard-Verhalten, jeder passt selbst auf); wer sie will, schaltet sie in den Einstellungen wieder ein. Ungeprüft im Spiel.
- 0.1.15: Nachnahme-Briefe, zu denen es keinen Brett-Auftrag gibt (zum Beispiel eine Abmachung mit einem Gildenmitglied), lassen sich wieder nehmen: Statt einer Sperre erscheint eine rote Warnung, und du bestätigst mit dem zweiten Klick. Das gilt auch, wenn die Nachnahme höher ist als vereinbart oder der Auftrag schon erfüllt wurde. Neue Einstellung „Nachnahme mit dem Brett prüfen“ (Standard an, für den ganzen Account); aus = keine Prüfung, jeder trägt selbst die Verantwortung. Ungeprüft im Spiel.
- 0.1.14: Das verschickte Item verschwindet jetzt sofort nach jedem einzelnen Brief aus der Liste (vorher erst am Ende aller Briefe). Neu: `/fwmail slots` zeigt, wie viele Anhänge ein Brief in diesem Spiel nimmt (Grundlage für mehrere Items je Brief). Ungeprüft im Spiel.
- 0.1.13: Nach dem Senden verschwinden die verschickten Anhänge aus der Liste im Senden-Reiter (jeder verschickte Brief einzeln; nicht verschickte bleiben stehen). Sind keine Anhänge mehr übrig, werden auch Betreff, Text, Gold und Nachnahme geleert.

### Lizenz
GPL-3.0, siehe `LICENSE`.

---

## English

### What is it?
Own mailbox window (optional, off by default): open all or selected mails safely, recent recipients, mailing lists with automation, several items per send, gold surplus, cash on delivery, archive and return to sender.

### Features
- Switch on: Settings > Mailbox > “Replace normal mailbox” or `/fwmail on` (`/fwmail off` switches back). The normal window stays open but invisible so board quests keep working.
- Inbox: “Open all” or “Open selected only”. One bag slot always stays free. Emptied mails are removed and saved in the archive first (searchable, retention adjustable).
- Cash-on-delivery mails are never taken automatically (“Pay and take” needs a second click). “Delete” never deletes them but returns them to the sender.
- Send: recipient with a list of recent ones, subject, text, items, gold, cash on delivery; several items are sent as several mails one after another, the pace adapts to the server.
- Mailing lists: per character name and items, “send automatically when the mailbox opens” and “send gold above …”. Items reserved for board quests are not sent.
- Board letters: with Creator and Brett the letter of a board quest is prepared in the Freewood mailbox and sent automatically once everything is correct (can be switched off).

### Dependencies
- Required: `Freewood-Core`
- Optional: `Freewood-Creator`, `Freewood-Brett`

### Commands
- `/fwmail`: Fenster ein- oder ausblenden (bei offenem Briefkasten)
- `/fwmail on` / `/fwmail off`: eigenen Briefkasten ein- oder ausschalten
- `/fwmail archive`: Archiv öffnen

### Installation
Copy the folder `Freewood-Mail` to `World of Warcraft\_forever_\Interface\AddOns\`. New files only load after a full game restart; a `/reload` is enough only when existing files changed. To see errors: `/console scriptErrors 1`, then `/reload`.

### Notes

- Taken over from the OctoWoW version (code only). Not yet verified in game; the link to Brett is not complete yet (Brett is still at the older state in Forever).
- Mail no longer replaces Blizzard functions (`DeleteInboxItem`, `UseContainerItem`): that caused “Freewood-Mail was blocked” when using items on Forever. As a result there is no right-click attaching any more (drag items or use “Add items”) and no protection against deleting cash-on-delivery mails in the Blizzard window.
- 0.3.3: Mailing lists and sending now also find items in the reagent bag (bag 5: herbs, ores, oils were missing and showed as "not in your bags"). New in the picker: a drop box at the top; dragging an item from your bags into it adds it (mailing list: the item; sending: the first free stack). Not verified in game whether Forever has the reagent bag.
- 0.3.2: Fixed: "Take all" and "Open all" left the rest behind when a mail held several identical stacks (e.g. 4x "Silverleaf x20"), because the mail looked the same after each take and was given up after 3 tries. Tries now count per state (number of attachments and first slot).
- 0.3.1: Fixed: in the normal design the mailbox showed the "Legion der Affen" artwork behind it on first opening, until you switched to Legion and back. Freshly created parts are now shown or hidden correctly right away.
- 0.3.0: The detail view shows all attachments as a grid like the Blizzard frame (up to 16, count, quality border, tooltip per item). Clicking an icon takes just that item (not for cash on delivery); the button "Take all (n)" takes everything from this mail one after another. Fixed: gaps in attachment slots (after taking from the middle) were not recognised; now all slots are read and taken by slot. Test `texlua tests/attach_test.lua`. Not verified in game.
- 0.2.2: Mailbox: close button is now a large "X" centred in the ring (no button graphic); wooden buttons centred, slim planks added (core 0.46.1).
- 0.2.1: Mailbox: wooden buttons and scroll bars from the core (follow the mailbox design: Legion = always, Normal = never, Automatic = overall design); the note at the bottom no longer runs under the parchment. Needs Freewood-Core 0.46.0. Unchecked in game.
- 0.2.0: New mailbox design "Legion of the Apes" (file `MailSkin.lua`, images in `Media/Legion`): fixed wooden frame (1100×733), leather background, the tabs Inbox/Send/Lists as a dropdown at the top inside the frame, parchment behind the reading pane, rows with a gold (opened) and red (mouse over) bar, red close button in the ring. Setting "Mailbox design": Automatic (follows the overall design "Legion of the Apes"), Normal or Legion of the Apes. Reversible, the normal window stays unchanged. Unchecked in game (image loading, position of dropdown and close button, readability on the parchment). Buttons and scroll bars are not in the new style yet.
- 0.1.16: The cash-on-delivery check is now off by default and reset to off once (Blizzard behaviour, everybody watches out themselves); turn it back on in the settings if wanted. Unchecked in game.
- 0.1.15: Cash-on-delivery mails without a board quest (for example an agreement with a guild mate) can be taken again: instead of a block a red warning appears and you confirm with the second click. This also applies if the amount is higher than agreed or the quest was already fulfilled. New setting "Check cash on delivery against the board" (default on, account-wide); off = no check, everyone is responsible themselves. Unchecked in game.
- 0.1.14: The sent item now disappears from the list right after each single mail (before: only at the end of all mails). New: `/fwmail slots` shows how many attachments one mail takes in this game (basis for several items per mail). Unchecked in game.
- 0.1.13: After sending, the sent attachments disappear from the list in the Send tab (each sent mail individually; unsent ones stay). When no attachments are left, subject, text, gold and cash on delivery are cleared too.

### License
GPL-3.0, see `LICENSE`.

## Tastenbelegung · Key bindings
**DE:** Unter Optionen > Tastaturbelegung gibt es einen eigenen Abschnitt für dieses Modul. Dort lässt sich eine Taste zum Öffnen und Schließen des Reiters belegen (zum Beispiel J für die Gilde). Ist der Reiter schon offen, schließt dieselbe Taste das Fenster. Nach der Installation einmal das Spiel neu starten, damit die neue Datei Bindings.xml gelesen wird.
**EN:** Options > Key Bindings has its own section for this module. Bind a key to open and close the tab (for example J for the guild). If the tab is already open, the same key closes the window. Restart the game once after installing so the new Bindings.xml file is read.
