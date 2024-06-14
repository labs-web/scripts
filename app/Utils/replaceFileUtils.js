const fs = require('fs');


/**
 * https://www.npmjs.com/package/replace-in-file
 *  
 * */        
function replaceFile(filePath ,oldStrings,newStrings){

    // let data = fs.readFileSync(filePath, 'utf8') ;

    // fs.unlinkSync(filePath);

    // oldStrings.forEach((oldString,i) => {
    //     data = data.replace(new RegExp(oldString, 'g'), newStrings[i]); // Use regular expression for global replacement
    // }); 
      
    // fs.writeFileSync(filePath, data, 'utf8'); 

    fs.readFile(filePath, 'utf8', (err, data) => {
        if (err) {
          console.error('Error reading file:', err);
        } else {

         
          oldStrings.forEach((oldString,i) => {
            data = data.replace(new RegExp(oldString, 'g'), newStrings[i]); // Use regular expression for global replacement
          }); 
      

          fs.writeFileSync(filePath, data, 'utf8');

          // fs.writeFileSync(filePath, data, 'utf8', (writeErr) => {
          //   if (writeErr) {
          //     console.error('Error writing to file:', writeErr);
          //   } else {
          //     console.log('File content replaced successfully!');
          //   }
          // });
          
        }
      });



}

module.exports = {
    replaceFile
};
        