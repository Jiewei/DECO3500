package {

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

		var Circle=new Shape;
		var Line=new Shape;
		var time:Number=10;//edit it to change time limit duration 
		var counter:Number=0;
		var rotator:Number=0;
		var myTimer:Timer=new Timer(1000);
		var newFormat:TextFormat=new TextFormat;
		var QuestionTextField=new TextField;
		var QuestionTextField2=new TextField;
		var questions:Array=new Array;
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


		public function FlashQuiz():void {

			questions[0]="What is the most common Element on Earth?";
			questions[1]="How Long Does it take for light from the moon to reach the Earth?";
			questions[2]="How many miles high is Mount Everest?";
			questions[3]="Which Ocean goes to the deepest depths?";
			questions[4]="What is the Currency in Chili ? ";
			questions[5]="What is 4ft 8inches in Metres ?";
			questions[6]="How many members were originally in the group Spice Girls ?";
			questions[7]="If I take 2 apples out of a basket containing 6 apples how many apples do I have ?";
			questions[8]="What is your birth sign If you were born November 25th ?";
			questions[9]="What year did the Vietnam war end?";

			answers=[["Hydrogen","Oxygen","Human beings","Soil"],["1.26 Secs","1.62 Secs","6.21 Secs","2.16 Secs"],["8.846","8.864","8.486","8.648"],["Pacific Ocean","Atlantic Ocean","Indian Ocean","Southern Ocean"],["Peso","Abasi","Cedi","Denar"],["1.42 Metres","1.24 Metres","4.12 Metres","2.41 Metres"],["5","6","7","8"],["2","6","4","3"],["Sagittarius","Capricorn","Pisces","Libra"],["1975","1979","1875","2008"]];


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

		public function StartButtonCLICK(e:MouseEvent):void {
			Text=ResultField.getChildAt(0);
			Text.text="";
			nextQuestion();
		}



		function nextQuestion():void {

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
			rotator=rotator + 360 / time;
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


	}
}