#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os
import sys
import argparse
import subprocess
import logging
import time
import json
from lxml import etree
SCRIPT_DIR = os.path.dirname(os.path.abspath(os.path.realpath(__file__)))
sys.path.append(os.path.join(SCRIPT_DIR, '../../modules'))
from parsers import releasenote_parser as xml_parser
import logger


config_dict = {
    'Trunk_R4_PreCheck': {'xsl_file': 'precheck.xsl', 'html_file': 'Trunk_R4_PreCheck.html'}
}


def json_to_xml(data_dict):
    root = xml_parser.create_node('cbts_status', attri_dict={'version': '11'})
    key_list = list(data_dict.keys())
    log.debug(key_list)
    key_list.sort(reverse=True)
    key_list = key_list[0:int(args.num)]
    for key in key_list:
        log.info('create {} tag'.format(key))
        precheck = xml_parser.add_node(root, "precheck", {'date': key})
        for stage in data_dict[key].keys():
            stage_attri = dict()
            for item in data_dict[key][stage].keys():
                log.info('{} stage {}:{}'.format(
                    stage,
                    item.lower(),
                    data_dict[key][stage][item]))
                stage_attri[item.lower()] = data_dict[key][stage][item]
            xml_parser.add_node(precheck, stage, stage_attri)
            del stage_attri
            log.info('collect {} stage finish'.format(stage))
        del precheck
        log.info('collect {} date finish'.format(key))
    xml_parser.write_xml(root, '{}.xml'.format(args.branch))
    return '{}.xml'.format(args.branch)


def create_html(xsl_file, html_file, xml_file):
    """
    use XSL to get information from xml then create html file
    :param project: project name
    :param root: xml object
    :return:None
    """
    root = etree.parse(xml_file).getroot()
    xsl = etree.parse(xsl_file)
    style = etree.XSLT(xsl)
    result = style.apply(root)
    string_html = str(result)
    with open(html_file, 'w+') as pf:
        pf.write(string_html)


def argument():
    parse = argparse.ArgumentParser()
    parse.add_argument('--json_file', '-j', required=False, help='json file')
    parse.add_argument('--num', '-n', required=False, help='data number')
    parse.add_argument('--branch', '-b', required=False, help='branch')
    return parse.parse_args()


if __name__ == '__main__':
    args = argument()
    log = logger.setup_logger(filename='status.log', debug='True')
    file = open(args.json_file,'r',encoding='utf-8')
    json_dict = json.load(file)
    file.close()
    log.debug(json_dict)
    xml_file = json_to_xml(json_dict)
    create_html(
        config_dict[args.branch]['xsl_file'],
        config_dict[args.branch]['html_file'],
        xml_file)
