---
layout: default
order: 1
---
{% assign pages = site.pages | sort: "order" %}
{% for page in pages %}
  {% if page.chapitre == "GestionProjects" or page.package == "GestionProjects" %}
    {{- page.content | markdownify -}}
  {% endif %}
{% endfor %}
