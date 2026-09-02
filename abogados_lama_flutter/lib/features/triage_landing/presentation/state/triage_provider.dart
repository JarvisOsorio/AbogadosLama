import 'package:flutter/material.dart';
import '../../domain/entities/lead_entity.dart';
import '../../domain/usecases/submit_triage.dart';
import 'triage_state.dart';

class TriageNotifier extends ValueNotifier<TriageState> {
  final SubmitTriage submitTriageUseCase;

  TriageNotifier({required this.submitTriageUseCase})
      : super(const TriageState());

  void setRequirementType(RequirementType type) {
    value = value.copyWith(requirementType: type);
  }

  void setUrgencyState(UrgencyState state) {
    value = value.copyWith(urgencyState: state);
  }

  void setCaseDescription(String description) {
    value = value.copyWith(caseDescription: description);
  }

  void setContactDetails({
    required String name,
    required String email,
    required String phone,
  }) {
    value = value.copyWith(
      clientName: name,
      clientEmail: email,
      contactPhone: phone,
    );
  }

  bool nextStep() {
    if (value.currentStep == 1 && !value.isStep1Valid) return false;
    if (value.currentStep == 2 && !value.isStep2Valid) return false;
    if (value.currentStep == 3 && !value.isStep3Valid) return false;

    if (value.currentStep < 4) {
      value = value.copyWith(currentStep: value.currentStep + 1);
      return true;
    }
    return false;
  }

  void prevStep() {
    if (value.currentStep > 1) {
      value = value.copyWith(currentStep: value.currentStep - 1);
    }
  }

  Future<void> submit() async {
    if (!value.isStep4Valid) return;

    value = value.copyWith(status: TriageStatus.submitting);

    try {
      final lead = value.toEntity();
      final trackingCode = await submitTriageUseCase(lead);
      value = value.copyWith(
        status: TriageStatus.success,
        successTrackingCode: trackingCode,
      );
    } catch (e) {
      value = value.copyWith(
        status: TriageStatus.failure,
        errorMessage: e.toString(),
      );
    }
  }

  void reset() {
    value = const TriageState();
  }
}
