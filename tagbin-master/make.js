#!/usr/bin/env node

var fs = require('fs'),
	less = require('less'),
	coffee = require('coffee-script'),
	jade = require('jade'),
	stylus = require('stylus'),
	path = require('path');

var _currentDir = __dirname,
	_configPath = path.resolve(_currentDir, "./source", 'config.json');


var config = JSON.parse( fs.readFileSync(_configPath, 'utf-8') );

// Process Arguments Here
process.argv.forEach(function(val, index, array){
	if( val ==='vendors' ){
		buildVendors();
	}
	else if(val=='stylus'){
		buildStylus();
	}
	/* Disabled for now
	else if(val==='less'){
		buildLess();
	}
	*/
	else if(val=='deploy'){
		deployVersion();
	}
	else if(val==='jade'){
		buildJade();
	}
	else if(val==='coffee'){
		buildCoffeeScripts();
	}
	else if(val==='tags'){
		readTags();
	}
	else if(val==='all'){
		buildVendors();
		
		//buildStyles();	Disabled for now

		//buildLess();
		buildStylus();
		buildJade();
		buildCoffeeScripts();
		readTags();
	}
});


function buildJade(){
	var exec = require('child_process').exec, 
		child,
		_sourcePath = path.resolve( _currentDir , './source/jade' ),
		_destPath = path.resolve( _currentDir, './current');

	var _cmd = "jade " + _sourcePath + " -P -D -o " + _destPath;
	
	child = exec( _cmd , function(error, stdout, stderr){
		if(error!==null){ console.log("Exec err: " + error); }
		else{ 
			console.log("Compiled .jade successfully."); 
			//cleanUp(); 	Disabled for now
		}
	});
	
	function cleanUp(){
		var exec = require('child_process').exec, 
			child;
		var _cmdString = "rm ./build/__* && rm ./build/layout.html",
			_cmdStringWin = "del .\\build\\layout.html";

		var _cmd;
		if(require('os').platform()==='win32'){_cmd = _cmdStringWin;}
		else{_cmd = _cmdString;}

		child = exec(_cmd, function(error,stdout,stderr){
			if(error!==null){ console.log("Exec err: " + error); }
			else{ console.log("Cleanup Done."); }
		});
	}
}



function deployVersion(){
	var exec = require('child_process').exec,
		child
		bpath = path.resolve( _currentDir, './current' ),
		dpath = path.resolve(_currentDir, './buiild'),
		_cmd = "cp -r ";

	child = exec(_cmd, function(error, stdout, stderr){

	});
}

function buildLess(){
	var exec = require('child_process').exec,
		child,
		srcPath = path.resolve( _currentDir, "./source/less/style.less" ),
		destPath = path.resolve( _currentDir, "./current/static/css/style.css");

	var _cmd  = "lessc " + srcPath + " " + destPath;
	console.log(_cmd);
	// Requires less to be installed globally
	child = exec( _cmd, function(error, stdout, stderr){
				if(error!==null){
					console.log('exec error: ' + error);
				}
				else console.log("Compiled style.less successfully.");
			});
}

function buildCoffeeScripts(){

	var _coffeeBundle = '',
	_coffeeBundle = fs.readFileSync(path.resolve(_currentDir, './source/coffee/tagbin.coffee'), 'utf-8') + "\n\n\n\n\n";
	
	fs.readdir(path.resolve(_currentDir, './source/coffee'), function(err, files){
		files.forEach(function(_file){

			if(_file.substr(0,7)=='tagbin-'){
				_coffeeBundle = _coffeeBundle + fs.readFileSync(path.resolve(_currentDir, './source/coffee/' , _file),  'utf-8') + "\n\n\n\n\n";	
			}
			
			if(files.indexOf(_file)==files.length-1){
				fs.writeFileSync(path.resolve(_currentDir, './tmp/tagbin.coffee'), _coffeeBundle, 'utf-8');
				processCoffee();
			}
		});
	});

	function processCoffee(){
		var exec = require('child_process').exec,
			child;
		
		var mpath = path.resolve(_currentDir, './source/coffee/main.coffee'),
			bpath = path.resolve(_currentDir, './source/coffee/background.coffee'),
			opath = path.resolve(_currentDir, './current/static/js'),
			spath = path.resolve(_currentDir, './tmp');

		var _cmd = "cp " + mpath + " " + spath + " && " + "cp " + bpath + " " + spath + " && ";
			_cmd = _cmd + "coffee -c -b --output " + opath + " " + spath;
		var _ttmpp = 'cp ./source/coffee/main.coffee ./tmp/ && cp ./source/coffee/background.coffee ./tmp/ && coffee -c -b --output ./current/static/js ./tmp';
		child = exec(_cmd, function(error, stdout, stderr){
				if(error!==null){
					console.log('exec error: ' + error);
				}
				else console.log("Compiled .coffee files successfully.");
		}); 
	}
}


function buildVendors(){
	var stylesheets  = config.css,
		javascripts = config.js,
		_prefixCSS = path.resolve(_currentDir,"./current/static/css") + "/",
		_prefixJS = path.resolve(_currentDir, "./current/static/js") + "/",
		_bundleCSS = '',
		_bundleJS = '';

	console.log(_prefixCSS, _prefixJS);
	// Bundle vendor .css together
	for( var _k=0; _k<stylesheets.length; _k++){
		_bundleCSS = _bundleCSS + fs.readFileSync( _prefixCSS + stylesheets[_k], 'utf-8') + "\n\n\n\n\n\n";
	}

	// Bundle vendor .js together
	for( var _l=0; _l<javascripts.length; _l++){
		_bundleJS = _bundleJS + fs.readFileSync( _prefixJS + javascripts[_l], 'utf-8') + "\n\n\n\n\n\n";
	}	

	// Write output
	fs.writeFileSync( _prefixCSS + 'vendors-bundled.css', _bundleCSS , 'utf-8' );
	fs.writeFileSync( _prefixJS + 'vendors-bundled.js', _bundleJS , 'utf-8' );

	console.log( "Vendors Bundled." );
}

function buildStyles(){
	var _bundle = '',
		_prefix = './current/static/css/',
		_colors = config.styles.colors,
		_themes = config.styles.themes;

	// Bundle .less files together
	var _bundleLESSOrig = '',
		_lessDIR = './source/less/';
	var files = config.less;

	files.forEach(function(_file){
		//console.log(_file);
		_bundleLESSOrig = _bundleLESSOrig + fs.readFileSync(_lessDIR + _file, 'utf-8') + "\n\n\n\n\n";
		
		// Bundle .less files and process on reading the last one
		if(files.indexOf(_file)==files.length-1){
			processStyles();
			//writeBundle();
		}
	});



	function writeBundle(){
		fs.writeFileSync('./src/less/bundle.less', _bundleLESSOrig, 'utf-8');
		console.log( "Done" );	
	}
	
	function processStyles(){
		console.log("Compiling Styles...");
		var _bundleLESS = '';
		_bundleLESS = _bundleLESSOrig;
		for(var _j=0; _j<_themes.length; _j++){
			var _thisTheme = '';
			if(_themes[_j]=='light'){
				_thisTheme = '@baseLight';
			}
			else if(_themes[_j]=='dark'){
				_thisTheme = '@baseDark';
			}
			else console.log("No Theme Specified")

			for(var _k=0; _k<_colors.length; _k++){
				var _themeBundle = '',
					_thisColor = _colors[_k],
					_cstring = "@baseColor: " + _thisColor + ";";

				_themeBundle = _bundleLESS;	
				var _checkString = "@process: 'onNode';";
					_bcindex = _themeBundle.indexOf(_checkString);

				var _customParams = "@baseColor: " + _thisColor + ";\n";
					_customParams += "@baseTheme: " + _thisTheme + ";\n";
					_customParams += "@baseThemeText: " + _thisTheme + "Text;\n";
					_customParams += "@baseThemeBorder: " + _thisTheme + "Border;\n";
					_customParams += "@baseThemeWidget: " + _thisTheme + "Widget;\n";

				_themeBundle = _themeBundle.substr(0, _bcindex) + _customParams + _themeBundle.substr(_bcindex+_checkString.length);
	
				//fs.writeFileSync('./src/less/bundle.less', _themeBundle, 'utf-8');
				//console.log("Wrote File");
		
				// Build Less Files
				less.render( _themeBundle, function(err, css){
					var _fname = _prefix + 'style-' + _themes[_j].toLowerCase() + '-' + _thisColor.replace('@base', '').toLowerCase() + '.css';
					fs.writeFileSync( _fname, css, 'utf-8' );
					console.log("---Compiled - " + _fname);
				});
				
			}
		}
	}

}



function buildStylus(){
	var stylus = require('stylus'),
		_spath = path.resolve( _currentDir, "./source/stylus/style.styl"),
		_dpath = path.resolve( _currentDir, "./current/static/css/style.css");

	var _scode = fs.readFileSync(_spath, 'utf-8');

	stylus(_scode)
		.set('filename', 'style.css')
		.set('paths', [path.resolve(_spath, '..')])
		.import(path.resolve(_currentDir, "node_modules/nib"))
		.render(function(err, css){
			if(err) throw err;
			else{
				fs.writeFileSync(_dpath, css, 'utf-8');
				console.log(".styl compiled");
			}
		});

}



function readTags(){

	mutagen = require('mutagen');		// Mutagen wrapper
	_mp3Dir = path.resolve( _currentDir, "./current/static/music");	// Directory with mp3 files
	
	// Read .mp3 files and processTags
	fs.readdir( _mp3Dir, function(error, files){
		if( error ) throw error;
		
		// Filter out .mp3 files and extract fullpath
		files.map(function(item){
			return item.substr(-3)==='mp3'
		});

		
		console.log("Music: Found %s files.", files.length);
		
		// Send these to process tags
		processTags(files);

	});
}

var tagsLib = {
	data: {},
	length: null
};

function processTags(arr){
	var c = 0,
		_mp3Dir = path.resolve( _currentDir, "./current/static/music/"),
		files = arr;

	tagsLib.length = files.length

	console.log("Music: Processing Tags...");
	function nextFile(){
		if(c==files.length){
			finishTagRead();
			return;
		}
		var ff = [];
		ff.push( path.resolve(_mp3Dir, files[c]) );
		mutagen.read(ff, function(err, tags){
			if(err){
				return console.log(err);
			}
			var _key = (c+1).toString();
			tagsLib.data[_key] = tags[0];

			tagsLib.data[_key]['filePath'] = "./static/music/"+files[c]
			c++;
			nextFile();
		});
	}
	nextFile();

}

function finishTagRead(){
	var mtpath = path.resolve( _currentDir, "./current/music.json" );
	fs.writeFileSync(mtpath, JSON.stringify(tagsLib), 'utf-8');
	console.log("Music: Done");
}