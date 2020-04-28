import M from 'materialize-css';

const sidenav = {
  initialize(){
    const elems = document.querySelectorAll('.sidenav');
    return  M.Sidenav.init(elems);
  },
  destroy(){
    const elems = document.querySelectorAll('.sidenav');
    elems.forEach((el)=> {
      M.Sidenav.getInstance(el).destroy;
    });
  }
}

export default sidenav;
