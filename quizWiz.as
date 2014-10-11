package
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class quizWiz extends Sprite {
		
		// Global Variables here
		private var numModes:int = 3; // The number of modes in the game
		private var numQuestions:int = 10; // The number of questions in each mode
		private var questLeft:int = 3; // How many questions we want to go through
		private var mode; // The current mode of the game
		
		private var modeButtons:Array; // The array for storing all buttons at the start of the game
		private var answerButtons:Array; // The array for storing all buttons for the answers
		private var buttonEvent:Function; // A variable to store the current button function (To remove later)
		
		private var score:int; // The player's current score
		private var highScores:Array = new Array(numModes); // The current high scores
		
		public function quizWiz() {
			newGame();
		}
		
		/*
		 * This function handles creating the questions and all the mode buttons.
		 */
		private function newGame():void {
			var questions:Array = new Array(numModes); // The array where we will store all the questions
			for (var i:int = 0; i < numModes; i++) {
				questions[i] = new Array(numQuestions); // Creating an array for each question mode
			}
			populateQuestions(questions); // Filling those arrays with inputs
			
			modeButtons = new Array(numModes);  // An array for all the mode buttons
			var modeNames:Array = new Array(numModes);  // An array for all the mode names
			modeNames = ["geo1", "geo2", "geo3"];
			buttonEvent = modeClick(modeNames, questions);
			for (i = 0; i < numModes; i++) {
				modeButtons[i] = createButton(modeNames[i], i);
				modeButtons[i].addEventListener(MouseEvent.CLICK, buttonEvent);
				this.addChild(modeButtons[i]);
			}
		}
		
		private function theGame(questSet:Array):void {
			removeButtons(); // Remove buttons to avoid clogging up the memory
			if (questLeft == 0) {
				fanFare(); // In case of them finishing the game
			}
			else {
				var randQuest:Array = randomQuest(questSet); // Pick a random question from the array
				var answerOrder:Array = randomAnswer(randQuest); // Randomize the answer order
				answerButtons = new Array(answerOrder.length-1); // Instantiate the array for the answer buttons
				buttonEvent = answer(randQuest[1], questSet); // Make a new button event for them
				for (var i:int = 1; i < answerOrder.length; i++) {
					answerButtons[i - 1] = createButton(answerOrder[i], i - 1);
					answerButtons[i - 1].addEventListener(MouseEvent.CLICK, buttonEvent);
					this.addChild(answerButtons[i-1]);
				}
				questLeft--;
			}
		}
		
		private function fanFare():void {
			// Display score
			// Reset score
			// Add button to return to mode select
			//		This button will also remove one mode
			//		So numModes - 1 and questions will wash over it
			// Maybe add button to play again
		}
		
		private function randomQuest(questions:Array):Array {
			// As the current question array is an array (Set) of arrays (Questions), 
			// need to choose a random one.
			// For completeness and to avoid choosing the same array twice, remove the 
			// array (Question) from the array (Set) and return it.
			var randQues:Array = questions[Math.round(Math.random()*questions.length)]; // Get a random question from the set
			questions.splice(questions.indexOf(randQues), 1); // Remove the question from the set
			return randQues;
		}
		
		private function randomAnswer(question:Array):Array {
			// Clone the answer array
			var clone:Array = new Array(question.length);
			for (var i:int = 0; i < question.length; i++) {
				clone[i] = question[i]; // Make a deep copy of question
			}
			// Create a new array to randomly order the new array 
			// (With the question still at the front)
			var randomClone:Array = new Array();
			randomClone.push(clone.shift()); // Take the first element of clone (The question) and add it onto randomClone
			while (clone.length > 0) {
				var randInt:int = Math.round(Math.random()*(clone.length-1)); // Create a new random integer
				randomClone.push(clone[randInt]); // Add on a new random answer from clone to randomClone
				clone.splice(randInt, 1); // Remove that answer from clone
			}
			return randomClone;
		}
		
		/*
		 * A function to create a button
		 */
		private function createButton(buttonName:String, num:int):Sprite {
			// The text of the button
			var textField:TextField = new TextField();
			textField.name = "textField";
			textField.text = buttonName;
			textField.mouseEnabled = false;
			
			// The shape of the button
			var rectangleShape:Shape = new Shape();
			rectangleShape.graphics.beginFill(0xFF0000);
			rectangleShape.graphics.drawRect(0, 0, 100, 25);
			rectangleShape.graphics.endFill();
			
			// The actual button object
			var buttonSprite:Sprite = new Sprite();
			buttonSprite.addChild(rectangleShape);
			buttonSprite.addChild(textField);
			buttonSprite.x = 150*(num%3);
			buttonSprite.y = 50*int(num/3);
			
			return buttonSprite;
			
			// Example of how to change the text
/*			var tf:TextField = TextField(buttonSprite.getChildByName("textField"));
			tf.text = "button sprite text"; */
		}
		
		private function modeClick(modes:Array, questions:Array):Function {
			return function(e:MouseEvent):void {
				var modeText:TextField = TextField(e.currentTarget.getChildByName("textField"));
				mode = modes.indexOf(modeText.text); // Grab the index of the mode we are playing
				
				var questSet:Array = new Array(questions[mode].length); // Create a new array to store only that question set
				for (var i:int = 0; i < questions[mode].length; i++) {
					questSet[i] = questions[mode][i]; // Populate that new array
				}
				theGame(questSet); // Start the game
			}
		}
		
		private function answer(check:String, questSet:Array):Function {
			return function(e:MouseEvent):void {
				var answerText:TextField = TextField(e.currentTarget.getChildByName("textField"));
				if (answerText.text == check) { // If you have the right answer
					score++; // Needs to be more robust
					if (score > highScores[mode]) {
						highScores[mode] = score; // To keep track of the highScores
					}
				}
				theGame(questSet); // Back to the playing field
			}
		}
		
		/*
		 * A quick method to remove all buttons from the modes or answers, depending on which is which
		 */
		private function removeButtons():void {
			if (modeButtons.length > 0) {
				for each(var butt:Sprite in modeButtons) {
					butt.removeEventListener(MouseEvent.CLICK, buttonEvent);
					this.removeChild(butt);
				}
				modeButtons = [];
			} else if (answerButtons.length > 0) {
				for each(var but:Sprite in answerButtons) {
					but.removeEventListener(MouseEvent.CLICK, buttonEvent);
					this.removeChild(but);
				}
				answerButtons = [];
			}
		}
		
		/*
		 * Basically a text dump for all the questions. Format is as follows:
		 * questions[x][y] where questions is the array where we store all the questions,
		 * x is the index of the question set (For example: geography questions difficulty 1)
		 * and y is the index of the question number. Both indexes start at 0, due to computer code.
		 * The input is an array, with the data stored as:
		 * 					["Question", "Correct Answer", "Wrong answer", "Wrong answer", "Wrong answer"];
		 */
		private function populateQuestions(questions:Array):void {
			// Geography questions set 1, "geo1"
			questions[0][0]=["What is the most common Element on Earth?","Hydrogen","Oxygen","Human beings","Soil"];
			questions[0][1]=["How Long Does it take for light from the moon to reach the Earth?","1.26 Secs","1.62 Secs","6.21 Secs","2.16 Secs"];
			questions[0][2]=["How many miles high is Mount Everest?","8.846","8.864","8.486","8.648"];
			questions[0][3]=["Which Ocean goes to the deepest depths?","Pacific Ocean","Atlantic Ocean","Indian Ocean","Southern Ocean"];
			questions[0][4]=["What is the Currency in Chili ?","Peso","Abasi","Cedi","Denar"];
			questions[0][5]=["What is 4ft 8inches in Metres ?","1.42 Metres","1.24 Metres","4.12 Metres","2.41 Metres"];
			questions[0][6]=["How many members were originally in the group Spice Girls ?","5","6","7","8"];
			questions[0][7]=["If I take 2 apples out of a basket containing 6 apples how many apples do I have ?","2","6","4","3"];
			questions[0][8]=["What is your birth sign If you were born November 25th ?","Sagittarius","Capricorn","Pisces","Libra"];
			questions[0][9]=["What year did the Vietnam war end?","1975","1979","1875","2008"];
			
			// Geography questions set 2, "geo2"
			questions[1][0]="Blah", ["1", "2", "3", "4"];
			questions[1][1]="yarr", ["1", "2", "3", "4"];
			
			//etc
		}
	}
}