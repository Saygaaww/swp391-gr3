import codecs

with codecs.open('web/jsp/profile/view-profile.jsp', 'r', 'utf-8') as f:
    text = f.read()

import re
old_head = r'''<% Reader currentReader = (Reader) session.getAttribute(AuthUtil.SESSION_USER); 
   Employee currentEmployee = (Employee) session.getAttribute(AuthUtil.SESSION_EMPLOYEE_ID);
%>'''

new_head = '''<%
    Object sessionUser = session.getAttribute(AuthUtil.SESSION_USER);
    String pName = "—";
    String pEmail = "—";
    String pPhone = "—";
    String pRole = "—";
    String pAvatar = null;
    String pInitials = "?";
    boolean isReader = false;
    
    if (sessionUser instanceof model.Reader) {
        model.Reader r = (model.Reader) sessionUser;
        pName = r.getFullName();
        pEmail = r.getEmail();
        pPhone = r.getPhone() != null && !r.getPhone().isEmpty() ? r.getPhone() : "Chua c?p nh?t";
        pRole = r.getRoleName() != null ? r.getRoleName() : "Ð?c gi?";
        pAvatar = r.getAvatarUrl();
        pInitials = r.getInitials();
        isReader = true;
    } else if (sessionUser instanceof model.Employee) {
        model.Employee e = (model.Employee) sessionUser;
        pName = e.getFullName();
        pEmail = e.getEmail();
        pRole = e.getRoleName() != null ? e.getRoleName() : "Nhân viên";
        pInitials = pName != null && pName.length() > 0 ? String.valueOf(pName.charAt(0)).toUpperCase() : "?";
    }
%>'''

text = text.replace(old_head, new_head)

text = text.replace('<% if (currentReader != null && currentReader.getAvatarUrl() != null\n                                && !currentReader.getAvatarUrl().isBlank()) {%>', '<% if (pAvatar != null && !pAvatar.trim().isEmpty()) {%>')
text = text.replace('<% if (currentReader != null && currentReader.getAvatarUrl() != null\r\n                                && !currentReader.getAvatarUrl().isBlank()) {%>', '<% if (pAvatar != null && !pAvatar.trim().isEmpty()) {%>')
text = text.replace('<img src="<%= currentReader.getAvatarUrl()%>"', '<img src="<%= pAvatar %>"')
text = text.replace('<%= currentReader != null ? currentReader.getInitials() : "?"%>', '<%= pInitials %>')
text = text.replace('<%= currentReader != null ? currentReader.getFullName() : "—"%>', '<%= pName %>')
text = text.replace('<%= currentReader != null ? currentReader.getEmail() : "—"%>', '<%= pEmail %>')
text = text.replace('<span class="role-badge"><i class="fas fa-shield-alt"></i> <%= currentReader != null && currentReader.getRoleName() != null ? currentReader.getRoleName() : "Ð?c gi?"%></span>', '<span class="role-badge"><i class="fas fa-shield-alt"></i> <%= pRole %></span>')
text = text.replace('<button class="edit-btn" onclick="openEditModal()">', '<% if (isReader) { %><button class="edit-btn" onclick="openEditModal()"><i class="fas fa-pen"></i> Ch?nh s?a</button><% } %>')
text = text.replace('<div class="info-val"><%= currentReader != null && currentReader.getPhone() != null ? currentReader.getPhone() : "Chua c?p nh?t"%></div>', '<div class="info-val"><%= pPhone %></div>')
text = text.replace('<div class="info-val"><%= currentReader != null && currentReader.getRoleName() != null ? currentReader.getRoleName() : "Ð?c gi?"%></div>', '<div class="info-val"><%= pRole %></div>')

with codecs.open('web/jsp/profile/view-profile.jsp', 'w', 'utf-8') as f:
    f.write(text)
