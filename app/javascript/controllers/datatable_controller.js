import { Controller } from "stimulus"

let debounce = require('lodash/debounce');

export default class extends Controller {
  static targets = [ "submit", "order", "page", "limit", "submitEdit", "cancelEdit" ]

  connect(){
    this.submit = debounce(this.submit, 300).bind(this)
  }

  submit(e) {
    if (e.keyCode !== 13) {
      this.resetPageNumber();
      this.submitTarget.click(); // don't submit form again if enter is pressed
    }
    this.submitTarget.disabled = false;
  }

  submitWithoutDebounce() {
    this.submitTarget.click();
    this.submitTarget.disabled = false;
  }

  sort(event) {
    this.disableOtherSortButtons(event.currentTarget);

    const icon = event.currentTarget.firstChild;
    let order = 'asc'

    if (icon.dataset.icon === 'caret-up') {
      icon.dataset.icon = 'caret-down';
      order = 'desc';
    } else {
      icon.dataset.icon = 'caret-up';
    }

    const sortBy = event.currentTarget.parentNode.dataset.header
    this.orderTarget.value = `${sortBy}_${order}`

    this.submitWithoutDebounce();
  }

  disableOtherSortButtons(target) {
    document.querySelectorAll('.sort-btn').forEach((btn) => {
      btn.classList.remove('sort-enabled');
    })

    target.classList.add('sort-enabled');
  }

  selectPage(event) {
    this.pageTarget.value = event.currentTarget.innerHTML;
    this.submitWithoutDebounce();
  }

  setLimit(event) {
    this.limitTarget.value = event.currentTarget.value;
    this.submit(event);
  }

  resetPageNumber() {
    this.pageTarget.value = 1;
  }

  submitEdit(event) {
    this.submitEditTarget.click();
  }

  cancelEdit(event) {
    if(event.keyCode === 27) {
      this.cancelEditTarget.click();
    }
  }
}
