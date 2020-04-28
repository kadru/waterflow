import M from 'materialize-css';

const floatingActionButton = {
  initialize(){
    const elems = document.querySelectorAll('.fixed-action-btn');
    return M.FloatingActionButton.init(elems);
  }
}

export default floatingActionButton;
