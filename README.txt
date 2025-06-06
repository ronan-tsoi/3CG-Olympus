3CG Project
Ronan Tsoi

Programming Patterns:
Besides the game loop and update method patterns, my 3CG uses:
- Subclass sandbox: Information for cards (stats, unique abilities) is initialized in a subclass sandbox separate from the base card class. The buttons are also technically another subclass sandbox.
- States: The game manager uses a rudimentary state system.
- Singleton: The game manager and grabber classes are singleton instances.

Feedback:
I received feedback from Tyler, Hunter, and Jason for this project
Suggestions from feedback that I kept in mind included:
- Some formatting consistencies, consistent comment lines for explaining code
- Try not to get to bogged up with edge case helper functions in the gameManager
- Using the observer programming pattern could help with scaling player/card interactions later on for the final project

Postmortem:
Overall I think I did pretty alright for this project, there's definitely some organization/structuring choices I made that I'm pretty satisfied with such as my deckLoader class (that I designed to be expanded relatively easily for part of the final) and my subclassing for the buttons. Some of my code did get a bit messy, in particular the way it handles the difference between player and CPU output is kind of stupid in my cardData sandbox and location class scripts. Maybe there was a better way I could've implemented the states for the gameManager, but the location class is the only thing that I would really consider rewriting if I were to redo this project. I also had to do a little bit of hard coding for a bug that I couldn't figure out with CPU cards not flipping. Besides that, the actual assembly of the game went relatively smoothly since the Solitaire assignment prepared me pretty well for this project.

Assets:
The game currently does not use any assets.
Cards, buttons, etc. are drawn with LOVE2D's built in graphics functions