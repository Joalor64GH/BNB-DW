package;

import flixel.FlxG;
import towsterFlxUtil.CharacterEditor;

#if desktop
import openfl.Lib;
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import haxe.io.Path;
import sys.io.Process;
import sys.io.File;
import sys.FileSystem;
import ALSoftConfig;
#end

using StringTools;

class Main extends openfl.display.Sprite
{
	public function new()
	{
		super();
		
		addChild(new flixel.FlxGame(1280, 720, StartScreen, 60, 60, false, false));
		addChild(new openfl.display.FPS(10, 10, 0xFFFFFF));

		#if desktop
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, (e:UncaughtErrorEvent) -> {
			var stack:Array<String> = [];
			stack.push(e.error);

			for (stackItem in CallStack.exceptionStack(true)) {
				switch (stackItem) {
					case CFunction:
						stack.push('C Function');
					case Module(m):
						stack.push('Module ($m)');
					case FilePos(s, file, line, column):
						stack.push('$file (line $line)');
					case Method(classname, method):
						stack.push('$classname (method $method)');
					case LocalFunction(name):
						stack.push('Local Function ($name)');
				}
			}

			e.preventDefault();
			e.stopPropagation();
			e.stopImmediatePropagation();

			final msg:String = stack.join('\n');

			#if sys
			try {
				if (!FileSystem.exists('./crash/'))
					FileSystem.createDirectory('./crash/');

				File.saveContent('./crash/'
					+ Lib.application.meta.get('file')
					+ '-'
					+ Date.now().toString().replace(' ', '-').replace(':', "'")
					+ '.txt',
					msg
					+ '\n');
			} catch (e:Dynamic) {
				Sys.println("Error!\nCouldn't save the crash dump because:\n" + e);
			}
			#end

			FlxG.bitmap.dumpCache();
			FlxG.bitmap.clearCache();

			if (FlxG.sound.music != null)
				FlxG.sound.music.stop();

			Lib.application.window.alert('Uncaught Error: \n'
				+ msg
				+ '\n\nIf you think this shouldn\'t have happened, report this error to GitHub repository!\nhttps://github.com/Joalor64GH/Rhythmo/issues',
				'Error!');
			Sys.exit(1);
		});
		#end
	}
}
