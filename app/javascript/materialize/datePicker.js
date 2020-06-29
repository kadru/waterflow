
import M from 'materialize-css';

const datePicker = {
  initialize(){
    const datePickerOptions = {
      i18n: {
        cancel: 'Cancelar',
        clear: 'Limpar',
        done: 'Ok',
        months: ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"],
        monthsShort: ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Set", "Oct", "Nov", "Dic"],
        weekdays: ["Domingo","Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado"],
        weekdaysShort: ["Dom","Lun", "Mar", "Mie", "Jue", "Vie", "Sab"],
        weekdaysAbbrev: ["D","L", "M", "M", "J", "V", "S"]
      },
      format: 'yyyy/mm/dd'
    }
    const elems = document.querySelectorAll('.datepicker');
    return M.Datepicker.init(elems, datePickerOptions);
  }
}

export default datePicker;
