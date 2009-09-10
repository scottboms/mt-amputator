<?php
  function smarty_modifier_amputator($text) {
    return preg_replace("/&(?!#?[xX]?(?:[0-9a-fA-F]+|\w{1,8});)/i","&amp;",$text);
  }
?>