package
{
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	public class quizWiz extends Sprite {
		
		// Global Variables here
		private var numModes:int = 3; // The number of modes in the game
		private var numQuestions:int = 7; // The number of questions in each mode
		private var questLeft:int = 7; // How many questions we want to go through
		private var trueMode:int = 0;
		private var allQuestions:Array; // All of the available questions
		private var mode:int; // The current mode of the game
		private var modeNames:Array; // The list of modes in the game
		
		private var modeButtons:Array; // The array for storing all buttons at the start of the game
		private var answerButtons:Array; // The array for storing all buttons for the answers
		private var replayButton:Sprite; // The button to restart the game
		private var buttonEvent:Function; // A variable to store the current button function (To remove later)
		private var questionArea:TextField; // An area for the question
		private var loader:Loader =new Loader();
		
		private var score:int; // The player's current score
		private var scoreBoard:TextField = new TextField();
		private var highScores:Array; // The current high scores
		private var highArchive:Array = new Array(numModes);
		private var highBoard:TextField = new TextField();
		
		private var questionFormat:TextFormat = new TextFormat();
		private var titleFormat:TextFormat = new TextFormat();
		private var scoreFormat:TextFormat = new TextFormat();
		
		private var timerEnd:Function;
		private var circle:Shape = new Shape();
		private var line:Shape = new Shape();
		private var time:int = 10;//edit it to change time limit duration 
		private var rotator:int = 0;
		private var timer:Timer = new Timer(1000, time);
		private var timeHolder:TextField = new TextField();
		private var timeLeft:int = time;
		private var timerFormat:TextFormat = new TextFormat();
		
		
		public function quizWiz() {
			for (var i:int = 0; i < numModes; i++) {
				highArchive[i] = 0;
			}
			reset();
			timer.addEventListener(TimerEvent.TIMER, timerHandler);
		}
		
		private function reset():void {
			numModes = 3;
			trueMode = 0;
			allQuestions = new Array(numModes); // The array where we will store all the questions
			modeNames = new Array(numModes); // The array where we will store all the mode names
			for (var i:int = 0; i < numModes; i++) {
				allQuestions[i] = new Array(numQuestions); // Creating an array for each question mode
			}
			populateQuestions(); // Filling those arrays with inputs
			
			stage.addChild(loader);
			loader.x=0;
			loader.y=200;
			
			stage.color = 0x008080;
			numModes = 3;
			highScores = new Array(numModes); // The current high scores
			for (i = 0; i < numModes; i++) {
				highScores[i] = highArchive[i];
			}
			
			titleFormat.italic = true;
			titleFormat.bold = true;
			titleFormat.size = 48;
			titleFormat.color = 0xFFFFFF;
			
			questionFormat.italic = true;
			questionFormat.bold = true;
			questionFormat.size = 16;
			questionFormat.color = 0xFFFFFF;
			
			scoreFormat.italic = false;
			scoreFormat.bold = false;
			scoreFormat.size = 16;
			scoreFormat.color = 0xEEEEEE;
			
			newGame();
		}
		
		/*
		* This function handles creating the questions and all the mode buttons.
		*/
		private function newGame():void {
			questionArea = new TextField;
			questionArea.text = "NEWSWHIZ";
			questionArea.name = "question";
			questionArea.x = 80;
			questionArea.y = 100;
			questionArea.width = 300;
			questionArea.wordWrap = true;
			questionArea.setTextFormat(titleFormat);
			stage.addChild(questionArea);
			
			scoreBoard.setTextFormat(scoreFormat);
			highBoard.setTextFormat(scoreFormat);

			
			if (allQuestions.length < numModes) {
				numModes = allQuestions.length;
				replayButton.removeEventListener(MouseEvent.CLICK, replay);
				this.removeChild(replayButton);
			}
			questionArea.text = "NEWSWHIZ";
			modeButtons = new Array(numModes);  // An array for all the mode buttons
			buttonEvent = modeClick();
			for (var i:int = 0; i < numModes; i++) {
				modeButtons[i] = createButton(modeNames[i], i);
				modeButtons[i].addEventListener(MouseEvent.CLICK, buttonEvent);
				this.addChild(modeButtons[i]);
			}
			score = 0;
			
		}
		
		private function theGame(questSet:Array):void {
			removeButtons(); // Remove buttons to avoid clogging up the memory
			if (questLeft == 0) {
				fanFare(); // In case of them finishing the game
			}
			else {
				var randQuest:Array = randomQuest(questSet); // Pick a random question from the array
				var answerOrder:Array = randomAnswer(randQuest); // Randomize the answer order
				
				questionArea.text = randQuest[0];
				questionArea.setTextFormat(questionFormat);
				
				answerButtons = new Array(answerOrder.length-1); // Instantiate the array for the answer buttons
				buttonEvent = answer(randQuest[1], questSet); // Make a new button event for them
				for (var i:int = 1; i < answerOrder.length; i++) {
					answerButtons[i - 1] = createButton(answerOrder[i], i - 1);
					answerButtons[i - 1].addEventListener(MouseEvent.CLICK, buttonEvent);
					this.addChild(answerButtons[i-1]);
				}
				questLeft--;
				timer.reset();
				timer.start();
				timeHolder.text = String(timeLeft);
				timerFormat.italic = false;
				timerFormat.bold = true;
				timerFormat.size = 12;
				timerFormat.color = 0x00FF00;
				timeHolder.setTextFormat(timerFormat);
			}
		}
		
		private function fanFare():void {
			stage.removeChild(scoreBoard);
			questionArea.text = "You got " + String(score) + " out of a possible " + numQuestions*10;
			if (highScores[trueMode] > highArchive[trueMode]) {
				questionArea.appendText(" beating your previous score of " + String(highArchive[trueMode]) + " by " 
					+ String(highScores[trueMode]-highArchive[trueMode]));
				highArchive[trueMode] = highScores[trueMode];
			}
			questionArea.setTextFormat(questionFormat);
			stage.removeChild(highBoard);
			
			unDrawTimer();
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerEnd);
			
			replayButton = createButton("Replay?", 0);
			replayButton.addEventListener(MouseEvent.CLICK, replay);
			this.addChild(replayButton);
		}
		
		private function randomQuest(questions:Array):Array {
			// As the current question array is an array (Set) of arrays (Questions), 
			// need to choose a random one.
			// For completeness and to avoid choosing the same array twice, remove the 
			// array (Question) from the array (Set) and return it.
			var notWorking:int = Math.round(Math.random()*(questions.length-1));
			var randQues:Array = questions[notWorking]; // Get a random question from the set
			// Awful and hardcoded pictures
			var pic:String;
			if (randQues[1] == "Kmart") pic = "pic1.jpg";
			if (randQues[1] == "Masterchef") pic = "pic2.jpg";
			if (randQues[1] == "Kmart" || randQues[1] == "Masterchef") {
				loader.load(new URLRequest(pic));
				loader.visible=true;
			}
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
			rectangleShape.graphics.beginFill(0xBBBBBB); // The colour of the button
			rectangleShape.graphics.drawRect(0, 0, 100, 25); // The size of the button (The last two integers are width and height)
			rectangleShape.graphics.endFill();
			
			// The actual button object
			var buttonSprite:Sprite = new Sprite();
			buttonSprite.addChild(rectangleShape);
			buttonSprite.addChild(textField);
			buttonSprite.x = 125 + 150*(num%2); // x position
			buttonSprite.y = 225 + 50*int(num/2); // y position
			
			return buttonSprite;
			
			// Example of how to change the text
			/*			var tf:TextField = TextField(buttonSprite.getChildByName("textField"));
			tf.text = "button sprite text"; */
		}
		
		private function modeClick():Function {
			return function(e:MouseEvent):void {
				var modeText:TextField = TextField(e.currentTarget.getChildByName("textField"));
				mode = modeNames.indexOf(modeText.text); // Grab the index of the mode we are playing
				
				if (modeNames[mode] == "Environment") {
					trueMode = 1;
				} else if (modeNames[mode] == "Politics") {
					trueMode = 2;
				} else trueMode = 0;
				
				var questSet:Array = new Array(allQuestions[mode].length); // Create a new array to store only that question set
				for (var i:int = 0; i < allQuestions[mode].length; i++) {
					questSet[i] = allQuestions[mode][i]; // Populate that new array
				}
				
				scoreBoard.x = 20;
				scoreBoard.y = 20;
				highBoard.x = 310;
				highBoard.y = 20;
				highBoard.width = 200;
				scoreBoard.setTextFormat(scoreFormat);
				highBoard.setTextFormat(scoreFormat);
				
				scoreBoard.text = String("Score: " + score);
				scoreBoard.setTextFormat(scoreFormat);
				stage.addChild(scoreBoard);
				
				highBoard.text = "Highscore for " + modeNames[mode] + ": " + String(highScores[trueMode]);
				highBoard.setTextFormat(scoreFormat);
				stage.addChild(highBoard);
				
				timerEnd = timerListener(questSet);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerListener(questSet));

				drawTimer();
				
				theGame(questSet); // Start the game
			}
		}
		
		private function answer(check:String, questSet:Array):Function {
			return function(e:MouseEvent):void {
				var answerText:TextField = TextField(e.currentTarget.getChildByName("textField"));
				if (answerText.text == check) { // If you have the right answer
					score += (timer.repeatCount - timer.currentCount);
					scoreBoard.text = String("Score: " + score);
					scoreBoard.setTextFormat(scoreFormat);
					if (score > highScores[trueMode]) {
						highScores[trueMode] = score; // To keep track of the highScores
						highBoard.text = "Highscore for " + modeNames[mode] + ": " + String(highScores[trueMode]);
						highBoard.setTextFormat(scoreFormat);
					}
				}
				loader.visible = false;
				timer.reset();
				line.rotation=0;
				rotator=0;
				timeLeft = 10;
				theGame(questSet); // Back to the playing field
			}
		}
		
		private function timerListener(questSet:Array):Function {
			return function(e:TimerEvent):void {
				line.rotation=0;
				rotator=0;
				timeLeft = 10;
				theGame(questSet);
			}
		}

		private function replay(e:MouseEvent):void {
			score = 0;
			questLeft = 7;
			allQuestions.splice(mode, 1); // Remove the mode from questions
			modeNames.splice(mode, 1); // Remove the mode from the modes
			numModes--;
			stage.removeChild(questionArea);
			if (numModes == 0) reset();
			else newGame();
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
		private function populateQuestions():void {
			// The mode names, feel free to change them, the code won't break. Will just change what the buttons say
			modeNames[0] = "General";
			modeNames[1] = "Environment";
			modeNames[2] = "Politics";
			
			// Geography questions set 1, "Geography 1"
			allQuestions[0][0]=["What group is classified by the FBI as being the most dangerous threat to western civilization?","Al Hakam","The Kardashian's","Isis","One Direction"];
			allQuestions[0][1]=["What did Tony Abbott say was good for humanity this week?", "World Peace", "Coal", "Vegetables", "Gender equality"];
			allQuestions[0][2]=["Which major Australian chain had to recall this particular item of clothing this week?", "Kmart", "Target", "Woolworths", "Aldi"];
			allQuestions[0][3]=["What popular Australian TV show did these brothers controversially win this week?", "Masterchef", "The Bachelor", "Big Brother", "The Block"];
			allQuestions[0][4]=["Which newspaper has received criticism for their headline The monster chef and the he she after a transgender sex worker was murdered by her boyfriend?", "The Courier Mail", "Famous", "The Australian", "News Weekly"];
			allQuestions[0][5]=["Which of these bugs has had the most news time recently?", "Ebola", "Common Cold", "Horse flu", "Rabies"];
			allQuestions[0][6]=["Who was named 2014 Sportswoman of the year?", "Cathy Freeman", "Stephanie Rice", "Catherine Coz", "Sally Pearson"];
			
			// Geography questions set 2, "Geography 2"
			allQuestions[1][0]=["Example Question", "True", "False", "False", "False"];
			allQuestions[1][1]=["Example Question", "True", "False", "False", "False"];
			allQuestions[1][2]=["Example Question", "True", "False", "False", "False"];
			allQuestions[1][3]=["Example Question", "True", "False", "False", "False"];
			allQuestions[1][4]=["Example Question", "True", "False", "False", "False"];
			allQuestions[1][5]=["Example Question", "True", "False", "False", "False"];
			allQuestions[1][6]=["Example Question", "True", "False", "False", "False"];
			
			allQuestions[2][0]=["Example Question", "True", "False", "False", "False"];
			allQuestions[2][1]=["Example Question", "True", "False", "False", "False"];
			allQuestions[2][2]=["Example Question", "True", "False", "False", "False"];
			allQuestions[2][3]=["Example Question", "True", "False", "False", "False"];
			allQuestions[2][4]=["Example Question", "True", "False", "False", "False"];
			allQuestions[2][5]=["Example Question", "True", "False", "False", "False"];
			allQuestions[2][6]=["Example Question", "True", "False", "False", "False"];
			
			
			//etc
		}
		
		private function timerHandler(event:TimerEvent):void {
			rotator=rotator + 360 / time;
			line.rotation=- rotator;
			timeLeft --;
			timeHolder.text = String(timeLeft);
			timeHolder.setTextFormat(timerFormat);
		}
		
		private function drawTimer():void {
			circle.graphics.lineStyle(5,0x00FF00);
			circle.graphics.drawCircle(250,350,10);
			line.graphics.lineStyle(5,0x000000);
			line.graphics.lineTo(0,-5);
			line.x=250;
			line.y=350;
			timeHolder.x = 245;
			timeHolder.y = 320;
			stage.addChild(circle);
			stage.addChild(line);
			stage.addChild(timeHolder);
		}
		
		private function unDrawTimer():void {
			stage.removeChild(circle);
			stage.removeChild(line);
			stage.removeChild(timeHolder);
		}
	}
}