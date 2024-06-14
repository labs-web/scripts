const show_debug_message = true;

function message(message){

    // \u001B[32m: This is the escape code for setting the text color to green.
    // \u001B[0m: This resets the color back to default.
    console.log(`\u001B[30m${message}\u001B[0m`);
}


function info_message(message){

    // \u001B[32m: This is the escape code for setting the text color to green.
    // \u001B[0m: This resets the color back to default.
    console.log(`\u001B[32m${message}\u001B[0m`);
}




function warning_message(message){
    if(show_debug_message){ 

        console.log(`\u001B[33m${message}\u001B[0m`);
    }
}

function error_message(message){
    if(show_debug_message){ 

        console.log(`\u001B[31m${message}\u001B[0m`);
    }
}

function debug_message(message){
    if(show_debug_message){ 

        console.log(`debug : ${message}`);
    }
}


module.exports = {
    message,
    error_message,
    debug_message,
    warning_message,
    info_message
}