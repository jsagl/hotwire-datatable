import { Controller } from "stimulus"


export default class extends Controller {
  static targets = [ "submit", "order", "page", "limit" ]

  submit(e, resetPageNumber= true) {
    if (resetPageNumber) { this.resetPageNumber() }
    if (e && e.keyCode === 13) { return } // don't submit form again if enter is pressed

    this.submitTarget.click()
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
}
