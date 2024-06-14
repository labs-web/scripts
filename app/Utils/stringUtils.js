function toUpperCaseFirstLetter(str) {
    return str.charAt(0).toUpperCase() + str.slice(1);
}

function toLowerCaseFirstLetter(str) {
    return str.charAt(0).toLowerCase() + str.slice(1);
  }
  


module.exports = {
    toUpperCaseFirstLetter,
    toLowerCaseFirstLetter,
};

