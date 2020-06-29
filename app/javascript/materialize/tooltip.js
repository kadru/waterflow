import M from 'materialize-css';

const tooltip = {
  initialize(){
    var elems = document.querySelectorAll('.tooltipped');
    return M.Tooltip.init(elems);
  }
}

export default tooltip
