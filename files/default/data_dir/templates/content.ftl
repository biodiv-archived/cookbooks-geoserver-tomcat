<#list features as feature>
{
layer:'${type.name}',
featureid:'${feature.fid}',
  <#list feature.attributes as attribute>
    <#if !attribute.isGeometry>
        ${attribute.name}: '${attribute.value}'
    <#else>
        ${attribute.name}: ''
    </#if>
    <#if !(attribute.name == feature.attributes?last.name)>, 
    </#if>
  </#list>
},
</#list>
