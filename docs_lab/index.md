---
layout: rapport
order: 1
---

# Rapports

<a href="/{{site.data.lab_info.lab_reference}}/rapport_global/rapport"> Rapport globale </a> 

## Par packages

<ul>
  {% for package in site.data.lab_info.packages %}
    <li> <a href="/{{site.data.lab_info.lab_reference}}/{{ package.name }}/rapport"> {{ package.titre }} </a> </li>
  {% endfor %}
</ul>
