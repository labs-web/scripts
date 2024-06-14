const { info } = require('console');
const fs = require('fs'); 
const { info_message, warning_message } = require('./uiUtils');

function createDirectoryIfNotExist(directoryPath){
    
    if (!fs.existsSync(directoryPath)) {
      fs.mkdirSync(directoryPath);
      return true;
    }
    return false;
    // if (!fs.existsSync(directoryPath)) {
    //   fs.mkdir(directoryPath,()=>{
    //     console.log('- Folder created:', directoryPath);
    //     callback();
    //   });
     
    // }
    // callback();
}


function isFileExist(destinationPath){

    if (fs.existsSync(destinationPath)) {
        return true;
        
    }else{
        return false;
    }
}


function copyFile(sourcePath,destinationPath,forceGeneration,generatorName = ""){
    if (!forceGeneration && fs.existsSync(destinationPath)) {
        warning_message (`- ${forceGeneration}  : ${destinationPath} exist`);
    } else {
         fs.copyFileSync(sourcePath, destinationPath) 
         info_message(`- Create ${generatorName} : ${destinationPath}`)
    }
}

module.exports = {
    createDirectoryIfNotExist,
    isFileExist,
    copyFile
};