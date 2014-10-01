package {

	import flash.*;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.AntiAliasType;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;

	public class FlashQuiz extends MovieClip {
		
		// My instance variables
		var questSet:Array = new Array;
		
		// The example's instance variables
		/*
		var Circle=new Shape;
		var Line=new Shape;
		var time:Number=10; //The question time limit 
		var counter:Number=0;
		var rotator:Number=0;
		var myTimer:Timer=new Timer(1000);
		var newFormat:TextFormat=new TextFormat;
		var QuestionTextField=new TextField;
		var QuestionTextField2=new TextField;
		var answers:Array=new Array;
		var questionsLength:Number;
		var questionsLengthCheck:Number=1;
		var arr_randumNumbers:Array=new Array;
		var arr_randumNumbers2:Array=new Array;
		var m_iIndex:uint;
		var Text;
		var Qno:Number=1;
		var StartButton=CreateRect(0xCCCCCC,100,20);
		var answer1=CreateRect(0xCCCCCC,100,20);
		var answer2=CreateRect(0xCCCCCC,100,20);
		var answer3=CreateRect(0xCCCCCC,100,20);
		var answer4=CreateRect(0xCCCCCC,100,20);
		var ResultField=CreateRect(0xFFFFC4,300,50);
		var correctAnswer:String;
		var score:uint=0;
		var scoreTextField=new TextField;
		*/

		public function FlashQuiz():void {
			var i:int = 0;

			// Creating the questions and answers
			numModes:int = 3;  // The number of modes in the game
			var questions:Array = new Array(numModes);
			var numQuestions:int = 10;  // How many questions are in each mode
			for (i = 0; i < numModes; i++) {
				questions[i] = new Array(numQuestions); // Creating an accessable array for each question
			}
			populateQandA(questions);  // Creating the questions and answers
			
			// Creating the buttons for the different game modes
			var modeButtons:Array = new Array(numModes);  // An array for all the mode buttons
			var modeNames:Array = new Array(numModes);  // An array for all the mode names
			modeNames = ["geo1", "geo2", "geo3"];
			for (i = 0; i < numModes; i++) {
				modeButtons[i] = createButton(modeNames[i]);
				modeButtons[i].addEventListener(MouseEvent.CLICK, modeClick(modeButtons, modeNames, questions));
			}
			
			// Creating the timer and the stopwatch
			var stopWatch:Shape;
			var ticker:Shape;
			var rotator:Number = 0;
			var counter:Number = 0;
			var questionTime:Number = 10;  // The time for each question
			createTimer();
			var timer:Timer = new Timer(1000);
			timer.addEventListener("Timer", timerHandler(rotator, ticker, counter, questionTime));
			
			/*
			questionsLength=questions.length;
			shuffleArray();
			shuffleArray2();

			DrawTimer();
			myTimer.addEventListener("timer",timerHandler);

			newFormat.size=20;
			newFormat.bold=true;
			newFormat.color=0x000000;
			newFormat.align=TextFormatAlign.LEFT;
			newFormat.font="Verdana";

			QuestionTextField.text="Welcome to QuizWiz";
			QuestionTextField.width=250;
			QuestionTextField.selectable=false;
			QuestionTextField.setTextFormat(newFormat);
			QuestionTextField.x=165;
			QuestionTextField.y=50;
			addChild(QuestionTextField);

			QuestionTextField2.width=200;
			QuestionTextField2.height=400;
			QuestionTextField2.multiline=true;
			QuestionTextField2.wordWrap=true;
			QuestionTextField2.selectable=false;
			QuestionTextField2.x=165;
			QuestionTextField2.y=75;
			addChild(QuestionTextField2);

			ResultField.width=200;
			ResultField.selectable=false;
			ResultField.x=0;
			ResultField.y=350;
			addChild(ResultField);

			Text = geo1.label;
			Text.text='Geographic Level 1';
			geoButton1.y = 400;
			geoButton1.x = 200;
			geoButton.buttonMode = true;
			addChild(geoButton1);
			geoButton.addEventListener(MouseEvent.CLICK, modeClick)

			Text=StartButton.getChildAt(0);
			Text.text="Geographic";
			StartButton.y=300;
			StartButton.x=150;
			StartButton.buttonMode=true;
			addChild(StartButton);
			StartButton.addEventListener(MouseEvent.CLICK,StartButtonCLICK);

			Text=answer1.getChildAt(0);
			Text.text="answers1";
			answer1.y=300;
			answer1.x=0;
			answer1.buttonMode=true;
			addChild(answer1);

			Text=answer2.getChildAt(0);
			Text.text="answers2";
			answer2.y=300;
			answer2.x=answer1.x + answer1.width + 5;
			answer2.buttonMode=true;
			addChild(answer2);

			Text=answer3.getChildAt(0);
			Text.text="answers3";
			answer3.y=300;
			answer3.x=answer2.x + answer2.width + 5;
			answer3.buttonMode=true;
			addChild(answer3);

			Text=answer4.getChildAt(0);
			Text.text="answers4";
			answer4.y=300;
			answer4.x=answer3.x + answer3.width + 5;
			answer4.buttonMode=true;
			addChild(answer4);

			answer1.visible=false;
			answer2.visible=false;
			answer3.visible=false;
			answer4.visible=false;

			answer1.addEventListener(MouseEvent.CLICK,answerCLICK);
			answer2.addEventListener(MouseEvent.CLICK,answerCLICK);
			answer3.addEventListener(MouseEvent.CLICK,answerCLICK);
			answer4.addEventListener(MouseEvent.CLICK,answerCLICK);

			addChild(ResultField);
			addChild(scoreTextField);

		}

		public function answerCLICK(e:MouseEvent):void {

			Text=e.target.getChildAt(0);
			if (Text.text == correctAnswer) {
				Text=ResultField.getChildAt(0);
				Text.text="Right";
				Text.setTextFormat(newFormat);
				score++;
			} else {
				Text=ResultField.getChildAt(0);
				Text.text="Wrong";
				Text.setTextFormat(newFormat);
			}
			nextQuestion();

		}

		//Several functions for each question set.
		public function StartButtonCLICK(e:MouseEvent):void {
			Text=ResultField.getChildAt(0);
			Text.text="";
			nextQuestion();
			//nextQuestion(whateverWasClicked);
		}



		function nextQuestion():void {
		//function nextQuestion(Str whateverWasClicked):void

			Text=StartButton.getChildAt(0);
			if (Text.text == "PlayAgain") {
				Qno=1;
				score=0;
				Text=ResultField.getChildAt(0);
				Text.text="";
			}
			if (Qno <= questionsLength) {

				answer1.visible=true;
				answer2.visible=true;
				answer3.visible=true;
				answer4.visible=true;

				myTimer.stop();
				myTimer.start();
				Line.rotation=0;
				rotator=0;
				counter=0;
				QuestionTextField.text="Question " + Qno;
				QuestionTextField.setTextFormat(newFormat);
				Text=StartButton.getChildAt(0);
				Text.text="Next";

				Text=answer1.getChildAt(0);
				correctAnswer=answers[arr_randumNumbers[Qno - 1]][0];
				Text.text=answers[arr_randumNumbers[Qno - 1]][arr_randumNumbers2[0]];

				Text=answer2.getChildAt(0);
				Text.text=answers[arr_randumNumbers[Qno - 1]][arr_randumNumbers2[1]];

				Text=answer3.getChildAt(0);
				Text.text=answers[arr_randumNumbers[Qno - 1]][arr_randumNumbers2[2]];

				Text=answer4.getChildAt(0);
				Text.text=answers[arr_randumNumbers[Qno - 1]][arr_randumNumbers2[3]];

				//Decides what question we get
				shuffleArray2();
				QuestionTextField2.text=questions[arr_randumNumbers[Qno++ - 1]];


			} else {

				Qno++;

				myTimer.stop();
				QuestionTextField.text="Completed";
				QuestionTextField.setTextFormat(newFormat);
				QuestionTextField2.text="";
				Text=StartButton.getChildAt(0);
				Text.text="PlayAgain";
				Line.rotation=0;
				rotator=0;


				answer1.visible=false;
				answer2.visible=false;
				answer3.visible=false;
				answer4.visible=false;
			}
			scoreTextField.text="Score " + String(score) + " / " + String(Qno - 2);
		}

		public function timerHandler(event:TimerEvent):void {
			rotator = rotator + 360 / time;
			Line.rotation=- rotator;
			counter++;
			if (counter==time) {
				counter=0;
				nextQuestion();
				Text=ResultField.getChildAt(0);
				Text.text="";
			}
		}


		public function DrawTimer():void {
			Circle.graphics.lineStyle(5,0x00FF00);
			Circle.graphics.drawCircle(100,100,50);
			Line.graphics.lineStyle(5,0x00FF00);
			Line.graphics.lineTo(0,-40);
			Line.x=100;
			Line.y=100;
			addChild(Circle);
			addChild(Line);
		}


		private function randomInRange(min:Number,max:Number):Number {
			var scale:Number=max - --min;
			return Math.ceil(Math.random() * scale + min);
		}

		function shuffleArray():void {
			var RanNumber:Number;
			arr_randumNumbers.splice(0,arr_randumNumbers.length);
			for (m_iIndex=0; m_iIndex < questionsLength; m_iIndex++) {
				while (arr_randumNumbers.indexOf(RanNumber=randomInRange(0,questionsLength - 1)) != -1) {
				}
				arr_randumNumbers.push(RanNumber);
			}
		}

		function shuffleArray2():void {
			var RanNumber:Number;
			arr_randumNumbers2.splice(0,arr_randumNumbers.length);
			for (m_iIndex=0; m_iIndex < 4; m_iIndex++) {
				while (arr_randumNumbers2.indexOf(RanNumber=randomInRange(0,3)) != -1) {
				}
				arr_randumNumbers2.push(RanNumber);
			}
		}
		*/
		
		private function theGame():void {
			/*
			 * We have a set of questions now, make a while loop that cycles through the
			 * questions, selecting them at random and reordering the answers, awarding 
			 * points for the right answer?
			 * Would probably be easier if it was implemented using a recursive function.
			 */
			 if (questSet.length == 0) {
				 gameOver();
			 } else {
				 var randQuest:Array = randomQuest(questSet);
				 var answerOrder:Array = randomAnswers(randQuest);
				 // TODO: 
				 //		Set the question text to be randQuest[0]
				 // 	Create buttons for the answers
				 //		Get the timer to work, might need instance variable for it Q.Q
				 // 	Create some game over code
			 }
		}
		
		private function randomQuest(questions:Array):Array {
			// As the current question array is an array (Set) of arrays (Questions), 
			// need to choose a random one.
			// For completeness and to avoid choosing the same array twice, pop the 
			// array (Question) from the array (Set) and return it.
			return questions.pop(round(Math.random()*questions.length));
		}
		
		private function randomAnswers(question:Array):Array {
			// Clone the answer array
			var clone:Array = new Array(questions[1].length);
			var i:int;
			for (i = 0; i < questions[1].length; i++) {
				clone[i] = questions[1][i];
			}
			// Create a new array to randomly order the new array
			var randomClone:Array = new Array();
			while (clone.length > 0) {
				randomClone.push(clone[round(Math.random()*clone.length)]);
			}
			return randomClone;
		}
		
		private function timerHandler(rotator:Number, ticker:Shape, counter:Number, time:Number):Function {
  			return function(e:TimerEvent):void {
				rotator = rotator + (360 / time);
				ticker.rotation=- rotator;
				counter++;
				if (counter==time) {
					counter=0;
					theGame();
				}
			};
		}
		
		public function DrawTimer(line:Shape, circle:Shape):void {
			circle.graphics.lineStyle(5,0x00FF00);
			circle.graphics.drawCircle(100,100,50);
			line.graphics.lineStyle(5,0x00FF00);
			line.graphics.lineTo(0,-40);
			line.x=100;
			line.y=100;
			addChild(circle);
			addChild(line);
		}
		
		private function CreateButton(buttonName:String):Button {
			var button:Button = new Button;
			button.label = buttonName;
			button.graphics.beginFill(0xCCCCCC, 2);
			button.graphics.drawRect(0, 0, 100, 20);
			button.graphics.endFill();
			button.selectable = false;
			return button;
		}
		
		private function modeClick(modeButtons:Array, modeNames: Array, questions:Array):Function {
  			return function(e:MouseEvent):void {
				// Gets the label of the button and gets the array associated with it
				var mode:int = modeNames.indexOf(e.currentTarget.label);
				questSet = questions[mode];
				//Some code here to cancel the mode buttons and hide them
				theGame();
				//Some new function here to cycle through the questions etc. The actual game
  			};
		}

/*
		The rest of my code for the click
		var functionOnClick:Function = onClick(true, 123, 4.56, "string");
		stage.addEventListener(MouseEvent.CLICK, functionOnClick);
		stage.removeEventListener(MouseEvent.CLICK, functionOnClick);
*/
		
		// Each array input has the question followed by 4 possible answers, the first answer being the correct one
		// So position 0 of the array (within the array) is the question, position 1 is the correct answer and the rest
		// (positions 2-4) are incorrect answers.
		private function populateQandA(questions:Array):void {
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


// The movie clip way of doing it below.

		private function CreateRect(color:Number,Width:Number,Height:Number):MovieClip {
			var Rect:MovieClip=new MovieClip;
			Rect.graphics.beginFill(color,2);
			Rect.graphics.drawRect(0,0,Width,Height);
			Rect.graphics.endFill();
			var textInBox=new TextField;
			textInBox.width=Width;
			textInBox.height=Height;
			Rect.addChild(textInBox);
			Rect.mouseChildren=false;
			textInBox.selectable=false;
			return Rect;
		}
		
		private function CreateButton(color:Number, width:Number, height:Number) {
			// Create the button
			var button:MovieClip = new MovieClip;
			button.graphics.beginFill(color, 2);
			button.graphics.drawRect(0, 0, width, height);
			button.graphics.endFill();
			
			// Instantiate the button's text
			var buttonName = new TextField;
			buttonName.width = width;
			buttonName.height = height;
			button.addChild(buttonName);
			button.mouseChildren = false;
			button.selectable = false;
			
			// Return the button
			return button;
		}
				
		private function populateButtons(array:Array) {
			var i:int;
			for(i = 0; i<array.length; i++) {
				// Create each button within the array
				array[i] = CreateButton(0xCCCCCC, 100, 20);
				
				Text = StartButton.getChildAt(0);
				Text.text="Geographic";
				StartButton.y=300;
				StartButton.x=150;
				StartButton.buttonMode=true;
				addChild(StartButton);
				StartButton.addEventListener(MouseEvent.CLICK,StartButtonCLICK);
			}
		}


	}
}