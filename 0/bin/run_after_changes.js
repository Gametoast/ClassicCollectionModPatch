// uses Windows Script Host jScript (.js) support
// cmd> cscript path\to\your\script.js

// debug with Visual Studio:
// C:\Windows\System32\cscript.exe /x run_after_changes.js
// more about debugging wscript (.vbs, .js) files:
// https://stackoverflow.com/questions/23210905/can-you-debug-vbscript-in-visual-studio/24693127#24693127


var forSwitch = false;
var shell = WScript.CreateObject("WScript.Shell");
var fso = new ActiveXObject("Scripting.FileSystemObject");
var currentDir = shell.CurrentDirectory;
var folderNameToFind = "_lvl_pc";
var folderNameToReplace = "lvl_common";
var expectedFolder1 = "addon"
var expectedFolder2 = "addon2"

function print(arg){
    WScript.Echo(arg);
}

function showMessageBox(message, title){
    // shell.Popup: https://www.vbsedit.com/html/f482c739-3cf9-4139-a6af-3bde299b8009.asp
    // WScript.Shell.Popup(strText, [nSecondsToWait], [strTitle], [nType]);
    shell.Popup(message, 0, title, 0x0 + 0x40);
}

function showErrorBox(message, title){
    shell.Popup(message, 0, title, 0x0 + 0x10); 
}

function runProgram(programPath, arguments){
    var  command =  programPath +" "+  arguments ;
    try{
        print("Running: " + command);
        shell.run(command, 1, true);
    } catch( exception){
        showErrorBox("Error running command:\r\n" + command
                + exception + "\r\n" , "Error!");
    }
}

function endsWith(str, suffix) {
    return str.substr(str.length - suffix.length,suffix.length) === suffix;
}

function writeFile(filePath, contents) {
    var file = fso.OpenTextFile(filePath,2, true);
    file.Write(contents);
    file.Close();
    WScript.Echo("File written successfully: " + filePath);
}

// rename folders + child folders
function renameFolders(folderToLookUnder) {
    var folder = fso.GetFolder(folderToLookUnder);
    var subFolders = new Enumerator(folder.SubFolders);

    for (; !subFolders.atEnd(); subFolders.moveNext()) {
        var subFolder = subFolders.item();
        if (subFolder.Name.toLowerCase() === folderNameToFind.toLowerCase()) {
            var newPath = subFolder.Path.replace(folderNameToFind, folderNameToReplace);
            fso.MoveFolder(subFolder.Path, newPath);
            print("Renamed: to " + newPath);
        }
        renameFolders(subFolder.Path);
    }
}

// Gets all the files under the given folder, populates the fileList array.
// folder:   a folder file system object (fso.GetFolder(path))
// fileList: a JavaScript array, initially should be empty.
function getAllFiles(folder, fileList) {
    var file, files = new Enumerator(folder.files);
    for (; !files.atEnd(); files.moveNext()) {
        file = files.item();
        fileList.push(file.Path);
    }
    var subFolders = new Enumerator(folder.SubFolders);
    for (; !subFolders.atEnd(); subFolders.moveNext()) {
        getAllFiles(subFolders.item(), fileList);
    }
}

function writeFakeFileSystem(){
    var folder = fso.GetFolder("."),
        allFiles = [];
    
    getAllFiles(folder, allFiles);
    var luaFileContent = "zero_patch_files_string = [[\r\n";
    for(var i =0; i < allFiles.length; i++){
        luaFileContent += allFiles[i] +"\r\n";
    }
    luaFileContent += "]]\r\n";
    writeFile("0\\patch_scripts\\fs.lua", luaFileContent);
}

// ===================== used for switch ==============================
function lowerCaseFiles(strDirectory) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var folder = fso.GetFolder(strDirectory);
    var files = new Enumerator(folder.Files);
    var file, tmp, oldName, newName, lowerName;

    for (; !files.atEnd(); files.moveNext()) {
        file = files.item();
        lowerName = file.Name.toLowerCase();
        if (file.Name != lowerName) {
            oldName = file.Path;
            newName = fso.BuildPath(file.ParentFolder, lowerName);
            tmp = oldName + "_tmp_";
            fso.MoveFile(oldName, tmp);
            fso.MoveFile(tmp, newName);
            print("Renamed to: " + newName);
        }
    }
}

function lowerCaseDirectories(strDirectory) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var folder = fso.GetFolder(strDirectory);
    var subFolders = new Enumerator(folder.SubFolders);
    var lowerName = folder.Name.toLowerCase();
    var oldName = folder.Path;
    var newName = fso.BuildPath(folder.ParentFolder, lowerName);
    var tmp;

    lowerCaseFiles(strDirectory);

    if (folder.Name != lowerName) {
        tmp = oldName + "__tmp__";
        fso.MoveFolder(oldName, tmp);
        fso.MoveFolder(tmp, newName);
        print("Renamed to: " + newName);
    }

    folder = fso.GetFolder(newName);
    subFolders = new Enumerator(folder.SubFolders);
    for (; !subFolders.atEnd(); subFolders.moveNext()) {
        lowerCaseDirectories(subFolders.item().Path);
    }
}
// ===================== used for switch end ==============================

// start of script functionality

print("Current Dir> " + currentDir);

// make sure we're in a good folder.
if(endsWith(currentDir,"addon") || endsWith(currentDir,"addon2")){
    print("Current folder is an addon folder, nice.");
} else {
    showErrorBox("Current folder is NOT an addon folder! Exiting!!", "Error!");
    WScript.Quit(1);
}

// running for the switch version?
for(var i = 0; i < WScript.Arguments.length; i++){
    if(WScript.Arguments(i).toLowerCase() === "-switch" ){
        forSwitch = true;
        print("will do switch specific lower-case operation");
    }
}

// Start the renaming process from the current directory
if(endsWith(currentDir,"addon2")){
    print("Check for folders to rename...");
    renameFolders(currentDir);

    if(forSwitch){
        print("Lower-case the files for switch.")
        lowerCaseDirectories(currentDir);
    }
}

print("Create the fake file system")
writeFakeFileSystem();

if(forSwitch){
    print("Creating fs.script for the switch version")
    runProgram("0\\bin\\ScriptMunge.exe", 
        " -sourcedir 0\\patch_scripts\\ -inputfile fs.lua -outputdir 0\\patch_scripts\\ ");
	// verify file exists "0\\patch_scripts\\fs.script"
    if(!fso.FileExists("0\\patch_scripts\\fs.script")){
        showErrorBox("'0\\patch_scripts\\fs.script' was not created by scriptmunge", "Error!");
        WScript.Quit(1);
    }
}

print("Done")
