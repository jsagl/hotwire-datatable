import { Controller } from "stimulus"


export default class extends Controller {
  static targets = [ "submit", "order", "page", "limit", "submitEdit", 'cancelEdit' ]

  submit(e, resetPageNumber= true) {
    if (resetPageNumber) { this.resetPageNumber() }
    if (e && e.keyCode === 13) { return } // don't submit form again if enter is pressed

    this.submitTarget.click()
    this.submitTarget.disabled = false;
  }

  sort(event) {
    const clickedSortButton = event.currentTarget

    this.disableOtherSortButtons(clickedSortButton);
    clickedSortButton.classList.add('sort-enabled');

    const order = this.setOrder(clickedSortButton.firstChild)
    const sortBy = clickedSortButton.parentNode.dataset.header

    this.orderTarget.value = `${sortBy}_${order}`
    this.submit(false, false);
  }

  disableOtherSortButtons(target) {
    document.querySelectorAll('.sort-btn').forEach((btn) => {
      btn.classList.remove('sort-enabled');
    })
  }

  setOrder(icon) {
    let order = 'asc'

    if (icon.dataset.icon === 'caret-up') {
      icon.dataset.icon = 'caret-down';
      order = 'desc';
    } else {
      icon.dataset.icon = 'caret-up';
    }

    return order
  }

  selectPage(event) {
    this.pageTarget.value = event.currentTarget.innerHTML;
    this.submit(false, false);
  }

  setLimit(event) {
    this.limitTarget.value = event.currentTarget.value;
    this.submit(event, true);
  }

  resetPageNumber() {
    this.pageTarget.value = 1;
  }

  submitEdit(event) {
    event.currentTarget.classList.remove('focused');
    event.currentTarget.form.querySelector('input[type="submit"]').click();
  }

  addFocusClass(event) {
    const inputField = event.currentTarget;
    inputField.classList.add('focused');
    this.moveCursorToStringEnd(inputField);
  }

  moveCursorToStringEnd(field) {
    setTimeout(function(){ field.selectionStart = field.selectionEnd = 10000; }, 0);
  }

  handleEditKeys(event) {
    if(event.keyCode === 27) { // do not submit changes if escape key is pressed
      this.cancelEditTarget.click();
    } else if (event.keyCode === 13) { //submit changes if enter is pressed
      this.submitEdit(event);
    }
  }
}
