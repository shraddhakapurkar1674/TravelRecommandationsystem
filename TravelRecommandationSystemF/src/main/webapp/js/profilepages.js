let currentStep = 1;
const totalSteps = 4;

function showStep(step) {
    document.querySelectorAll('.wizard-step').forEach(el => el.classList.remove('active'));
    document.getElementById(`step-${step}`).classList.add('active');

    document.querySelectorAll('.step-item').forEach((item, index) => {
        item.classList.remove('active', 'completed');
        if (index + 1 < step) {
            item.classList.add('completed');
            item.querySelector('.circle').innerHTML = '<i class="fa-solid fa-check"></i>';
        } else if (index + 1 === step) {
            item.classList.add('active');
            item.querySelector('.circle').textContent = index + 1;
        } else {
            item.querySelector('.circle').textContent = index + 1;
        }
    });

    const nextBtn = document.getElementById('next-btn');
    if (step === totalSteps) {
        nextBtn.innerHTML = 'Complete Profile <i class="fa-solid fa-check"></i>';
    } else {
        nextBtn.innerHTML = 'Next <i class="fa-solid fa-arrow-right"></i>';
    }

    const prevBtn = document.getElementById('prev-footer-btn');
    prevBtn.style.visibility = (step === 1) ? 'hidden' : 'visible';
}

function nextStep() {
    if (currentStep < totalSteps) {
        currentStep++;
        showStep(currentStep);
    } else {
        document.getElementById('travelProfileForm').submit();
    }
}

function prevStep() {
    if (currentStep > 1) {
        currentStep--;
        showStep(currentStep);
    }
}

function selectCompanion(element, value) {
    document.querySelectorAll('[data-group="traveler"]').forEach(el => el.classList.remove('active'));
    element.classList.add('active');
    document.getElementById('input_travel_companion').value = value;
}

function selectDuration(element, value) {
    document.querySelectorAll('#durationGroup .chip').forEach(el => el.classList.remove('active'));
    element.classList.add('active');
    document.getElementById('input_trip_duration').value = value;
}

function selectSingleGroup(element, groupName, inputId, value) {
    document.querySelectorAll(`[data-group="${groupName}"]`).forEach(el => el.classList.remove('active'));
    element.classList.add('active');
    document.getElementById(inputId).value = value;
}

function selectChip(element, groupName, inputId, value) {
    document.querySelectorAll(`[data-group="${groupName}"]`).forEach(el => el.classList.remove('active'));
    element.classList.add('active');
    document.getElementById(inputId).value = value;
}

showStep(currentStep);