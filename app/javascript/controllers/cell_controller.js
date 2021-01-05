import { Controller } from "stimulus"


export default class extends Controller {
    static targets = [ "submitEdit", 'cancelEdit' ]

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
        }
    }
}
