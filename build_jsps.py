import os, sys

dashboard_path = r'c:\Users\tenma\OneDrive\Documents\NetBeansProjects\Library\web\WEB-INF\jsp\admin\dashboard.jsp'
readers_in = r'c:\Users\tenma\OneDrive\Documents\NetBeansProjects\Library\dung_reader_list.jsp'
employees_in = r'c:\Users\tenma\OneDrive\Documents\NetBeansProjects\Library\dung_employee_list.jsp'
readers_out = r'c:\Users\tenma\OneDrive\Documents\NetBeansProjects\Library\web\WEB-INF\jsp\admin\users.jsp'
employees_out = r'c:\Users\tenma\OneDrive\Documents\NetBeansProjects\Library\web\WEB-INF\jsp\admin\employees.jsp'

with open(dashboard_path, 'r', encoding='utf-8') as f:
    dash_html = f.read()

sidebar_start = dash_html.find('<!-- SIDEBAR -->')
sidebar_end = dash_html.find('<!-- MAIN CONTENT -->')
sidebar = dash_html[sidebar_start:sidebar_end]

style_start = dash_html.find('<style>')
style_end = dash_html.find('</style>')
dash_styles = dash_html[style_start+7:style_end]

def process_jsp(in_path, out_path, title_icon, title_text):
    with open(in_path, 'r', encoding='utf-8') as f:
        html = f.read()
    
    html = html.replace('<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>', 
                        '<%@ page contentType="text/html;charset=UTF-8" language="java" %>\n<%@ page import="model.Employee, util.AuthUtil" %>\n<% Employee currentAdmin=(Employee) session.getAttribute(AuthUtil.SESSION_USER); %>')
    
    html = html.replace('<style>', '<style>\n' + dash_styles + '\n/* DUNG STYLES */\n')
    
    html = html.replace('body { font-family:', '/* body { font-family:')
    html = html.replace('.header { background:', '/* .header { background:')
    html = html.replace('.container { max-width:', '/* .container { max-width:')
    
    header_start = html.find('<div class="header">')
    header_end = html.find('<div class="container">')
    
    new_body = '<body>\n' + sidebar + '\n<!-- MAIN CONTENT -->\n<main class="main-content">\n'
    new_body += f'<div class="page-header"><h1 class="page-title"><i class="fas {title_icon}"></i> {title_text}</h1></div>\n'
    new_body += '<div style="max-width: 100%;">'
    
    html = html[:html.find('<body>')] + new_body + html[header_end + 23:]
    
    html = html.replace('</body>', '</div>\n</main>\n</body>')
    
    with open(out_path, 'w', encoding='utf-8') as f:
        f.write(html)
        
process_jsp(readers_in, readers_out, 'fa-users', 'Quản lý Độc giả')
process_jsp(employees_in, employees_out, 'fa-user-tie', 'Quản lý Nhân viên')
print("Done merging JSPs!")
