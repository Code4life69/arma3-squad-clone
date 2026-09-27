"""Strict reader for the text-config subset used in these unbinarized missions.

Checks syntax/structure, not engine config inheritance or asset availability.
Strings use doubled quotes; backslashes are literal Arma config path characters.
"""
from dataclasses import dataclass,field
import re
TOKEN=re.compile(r'\s+|//[^\n]*|/\*.*?\*/|"(?:""|[^"])*"|-?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?|[A-Za-z_]\w*|[{}\[\]=;:,]',re.S)
@dataclass
class Node:
    values:dict=field(default_factory=dict)
    classes:dict=field(default_factory=dict)
    imports:list=field(default_factory=list)
    parent:str|None=None

def parse(text):
    tokens=[];offset=0
    while offset<len(text):
        match=TOKEN.match(text,offset)
        if not match: raise ValueError(f'Invalid config character at byte {offset}: {text[offset:offset+20]!r}')
        token=match.group();offset=match.end()
        if token.isspace() or token.startswith(('//','/*')): continue
        tokens.append(token)
    index=0
    def take(expected=None):
        nonlocal index
        if index>=len(tokens): raise ValueError('Truncated config')
        token=tokens[index];index+=1
        if expected is not None and token!=expected: raise ValueError(f'Expected {expected!r}, found {token!r}')
        return token
    def value():
        token=take()
        if token=='{':
            items=[]
            while tokens[index]!='}':
                items.append(value())
                if tokens[index]==',': take(',')
                elif tokens[index]!='}': raise ValueError('Missing array comma')
            take('}');return items
        if token.startswith('"'): return token[1:-1].replace('""','"')
        if re.fullmatch(r'-?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?',token):
            return float(token) if any(c in token for c in '.eE') else int(token)
        if re.fullmatch(r'[A-Za-z_]\w*',token): return token
        raise ValueError(f'Expected config value, got {token!r}')
    def body(nested=False):
        node=Node()
        while index<len(tokens) and tokens[index]!='}':
            key=take()
            if key=='import':
                node.imports.append(take());take(';');continue
            if key=='class':
                name=take();parent=None
                if tokens[index]==':':take(':');parent=take()
                take('{');child=body(True);child.parent=parent;take('}');take(';')
                if name.lower() in {n.lower() for n in node.classes}:raise ValueError(f'Duplicate class {name}')
                node.classes[name]=child;continue
            if tokens[index]=='[':take('[');take(']')
            take('=');item=value();take(';')
            if key.lower() in {n.lower() for n in node.values}:raise ValueError(f'Duplicate property {key}')
            node.values[key]=item
        if nested and index>=len(tokens):raise ValueError('Unclosed class')
        return node
    try:
        result=body()
        if index!=len(tokens):raise ValueError('Unexpected closing brace')
        return result
    except IndexError as error:raise ValueError('Truncated config') from error
