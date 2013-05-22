require 'shelljs/global'

targets = ['/NET40', '/net40', '']
basePath = './packages'
appPath = './app'
nuget = if process.platform is 'win32' then '.\\tools\\nuget.exe' else 'mono ./tools/nuget.exe'

copyAssemblies = ->
	mkdir '-p', appPath
	console.log 'Copying assemblies...'

	packages = ls basePath
	assemblies = [].concat (findAssemblies pkg for pkg in packages)...
	for assembly in assemblies
		cp '-f', assembly, appPath
		console.log assembly

findAssemblies = (pkg) ->
	lib = "#{basePath}/#{pkg}/lib";
	for target in targets
		if test '-d', "#{lib}/#{target}"
			dlls = ls ls "#{lib}/#{target}/*.dll"
			return if dlls.length > 0 then dlls else ls "#{lib}/#{target}/*.exe"


config = require './frankie.json'
console.log config

for pkg in config.packages
	exec "#{nuget} install #{pkg} -o packages -Source http://www.myget.org/F/frankie"

copyAssemblies()
