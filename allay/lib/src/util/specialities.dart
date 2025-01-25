import 'package:allay/src/widgets/custom_icons.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'specialities.g.dart';

class SearchItem {
  final String label;
  final Icon? icon;
  final List<String>? tags;
  const SearchItem({required this.label, this.icon, this.tags});
}

@JsonSerializable(explicitToJson: true)
class Speciality {
  final String name;
  final List<String> tags;

  Speciality({required this.name, required this.tags});

  factory Speciality.fromJson(Map<String, dynamic> json) => _$SpecialityFromJson(json);
  Map<String, dynamic> toJson() => _$SpecialityToJson(this);

  SearchItem getSearchItem(){
    IconData icon = _specialityToIconMap[name]??Icons.search;
    return SearchItem(label: name, icon: Icon(icon), tags: tags);
  }

}

Map<String, IconData> _specialityToIconMap = {
  "Cardiology": MedicalIcons.heart,
  "Neurology" : MedicalIcons.neurology,
  "Gastroenterology": MedicalIcons.stomach,
  "Gynaecology" : MedicalIcons.female_reproductive_system,
  "General Physician" : MedicalIcons.stethoscope,
  "Pediatrics" : MedicalIcons.baby_0203_alt,
  "Ophthalmology" : MedicalIcons.eye,
  "Nephrology" : MedicalIcons.kidneys,
  "Dentist" : MedicalIcons.tooth,
  "Pulmonology" : MedicalIcons.lungs,
  "Orthopedics" : MedicalIcons.joints,
  "Dermatology" : MedicalIcons.allergies,
  "Oncology" : MedicalIcons.ribbon,
  "Psychology" : MedicalIcons.mental_disorders
};

const List<SearchItem> medicalSpecialities = [
  SearchItem(label: "Cardiology", icon: Icon(MedicalIcons.heart), tags: ['heart']),
  SearchItem(label: "Neurology", icon: Icon(MedicalIcons.neurology), tags: ['brain', 'nerves', 'spine']),
  SearchItem(label: "Gastroenterology", icon: Icon(MedicalIcons.stomach), tags: ['stomach', 'liver', 'appendix', 'pancreas', 'intestines', 'colon']),
  SearchItem(label: "Gynaecology", icon: Icon(MedicalIcons.female_reproductive_system), tags: ['gynaec', 'uterus', 'women', 'ladies']),
  SearchItem(label: "General Physician", icon: Icon(MedicalIcons.stethoscope), tags: ['family', 'family doctor']),
  SearchItem(label: "Pediatrics", icon: Icon(MedicalIcons.baby_0203_alt), tags: ['childrens', 'kids', 'children\'s']),
  SearchItem(label: "Ophthalmology", icon: Icon(MedicalIcons.eye), tags: ['eye']),
  SearchItem(label: "Nephrology", icon: Icon(MedicalIcons.kidneys), tags: ['kidney']),
  SearchItem(label: "Dentist", icon: Icon(MedicalIcons.tooth), tags: ['tooth']),
  SearchItem(label: "Pulmonology", icon: Icon(MedicalIcons.lungs), tags: ['lungs', 'chest']),
  SearchItem(label: "Orthopedics", icon: Icon(MedicalIcons.joints), tags: ['joint', 'bones', 'knee']),
  SearchItem(label: "Dermatology", icon: Icon(MedicalIcons.allergies), tags: ['skin', 'allergies']),
  SearchItem(label: "Oncology", icon: Icon(MedicalIcons.ribbon), tags: ['cancer']),
  SearchItem(label: "Psychology", icon: Icon(MedicalIcons.mental_disorders), tags: ['mental', 'mad']),
];

