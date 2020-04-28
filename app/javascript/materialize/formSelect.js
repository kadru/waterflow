import M from 'materialize-css';

const formSelect = {
  initialize(){
    const elems = document.querySelectorAll('select');
  
    return M.FormSelect.init(elems,{ classes: 'blue-text'});
  }
}

export default formSelect;