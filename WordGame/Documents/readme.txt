Leader: Hong Zhao
	note: Notes regarding application quality and time log can be found in the design document file

Running the Program
	First time running:
		1. Start the xcode simulator (either 3.5 or 4inch screen)
		2. Select the library button
		3. Press the '+' button
		4. Name your new library.
		5. Press ok
		6. Select the newly created library
		7. Press the '+' button to create new word/s
		8. Enter the word and press ok.
		9. Repeat until satisfied.
		10. Press 'Libraries' on the navigation bar
		11. Select home
		12. Press play button
		13. Select library in the tab bar
		14. Select the newly created library.
		15. Select Game on the tab bar
		16. Select one of the master option to enter the game board.
		17. tap on the letters to form the words to match that of 
			the newly created words in the library.
		18. After the game had ended and if enough ingredients are 
			discovered during the gameplay, go to the misc in the 
			startup screen by pressing the home button(note an scroll
			must be found in order for the compose to work).
		19. Select the scroll then the required ingredients and press
			compose.
		20. To use the power up, during the gameplay, swipe left the
			word display view to reveal the available powerups and 
			throw it into the gameplay zone.



Classes
./
	ViewController
		This class controls the initial screen of the app where there are 3 buttons and a background animation.
	AppDelegate
		This class is extended so that every other class can ask it for CoreData context.
./Play
	PlayTabBarController
		This class responds to the event where the user taps Home button on the navigation bar.
	NDTrie
		This class is a third-party implementation of trie structure that is used to represent all the words in the selected library at runtime.
	ItemDropModel
		This class takes different parameters to drop an item at different rate every time when a user finds a word.
./Play/Library
	LibraryTableViewController
		This class controls a table of currently available libraries for users to choose from before the game starts.
./Play/Level
	PlayView
		This class generates and maintains the bricks with letters on them during a gameplay.
	LevelViewController
		This class controls the screen where the user picks up a level, and reviews their current level and experience points
	PlayViewController
		This class controls the gameplay screen, and coordinates different views in that screen.
./Play/Level/Title View
	TitleView
		This class gives information about the currently selected letters, the number of words found and the time remaining. It also responds to user interactions like a single tap whereby all selected letters are undone, and a swipe from left to right whereby the usable item view is brought out.
	ExpBar
		This class summarises the user’s experience points and level.
	UsableItemView
		As mentioned earlier, this class holds all currently available usable items. It can be brought out of the screen by either swiping from left to right, or using an item.
./Misc
	MiscTabBarController
		This class responds to the event where the user taps Home button on the navigation bar.
./Misc/Compose
	ComposeCollectionView
		This class is essentially a collection view that holds the items.
	ComposeViewController
		This class controls the Compose screen, and coordinates different views inside it.
	ComposeView
		This class is the place where the composition logic and animation takes place, with an initial message saying “Drag A Scroll Here”.
	ItemDescriptionView
		This class holds the item name and description, and presents them to the user when the user taps on a particular item.
./Misc/Compose/ComposeViewCell
	ComposeCell
		This class is one cell of the collection view mentioned earlier on, which takes essentially one page.
	ItemCell
		This class is the view where the item image is actually shown, residing inside ComposeCell.
./Libraries
	LibrariesTableViewController
		This class controls the table where libraries can be added or deleted.
	WordsTableViewController
		This class controls the table where all words inside a selected library are shown. It also adds or deletes words from the library.
	WordCell
		This class is the cell inside the above 2 tables.
	DefinitionViewController
		This class controls web service connections whereby the definition of a selected word is pulled down from Aonaware Service.