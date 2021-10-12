//
//  CustomViewController.m
//  Proyecto
//
//  Created by mario on 10/10/21.
//

#import "CustomViewController.h"
#import <AFNetworking.h>
#import "Category.h"

/*@interface CustomViewController ()
{
    ViewController *vista;
}*/

//@end

@implementation CustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*vista = [[ViewController alloc] init];
    vista = _viewMain;
    [_lblUsuario setStringValue:_usuario];*/
    _categorias = [[NSMutableArray alloc] init];
    [self CargarDatos];
    
}

- (IBAction)onSalir:(id)sender {
    /*[vista cargarUsuario:@"Usuario"];
    
    [self dismissViewController:self];*/
}

- (IBAction)onEliminar:(id)sender {
}

-(void) CargarDatos{
    [_categorias removeAllObjects];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [self InicializarProgress];
    
    [manager GET:@"http://apiestudiosalle2.azurewebsites.net/v1/Categories/getAllCategories"
        parameters:nil
        headers:nil
        progress:nil
        success:^(NSURLSessionTask *task, id responseObject){
            self->datosJson = (NSDictionary *) responseObject;
            for (NSObject* key in self->datosJson) {
            
                Category *categoria = [[Category alloc] init];
                [categoria setCategoryID:(NSString *)[key valueForKey:@"categoryID"]];
                [categoria setCategoryName:(NSString *)[key valueForKey:@"categoryName"]];
                [categoria setDescription:(NSString *)[key valueForKey:@"description"]];
                            
                [self->_categorias addObject:categoria];
            }
            [NSThread sleepForTimeInterval:4.0f];
            [self->_Tabla reloadData];
            NSLog(@"Cargar datos %@", self->_categorias);
            [self FinalizarProgress];
        }
        failure:^(NSURLSessionTask *operation, NSError * error) {
            NSLog(@"Error: %@", error);
            [self FinalizarProgress];
        }];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return [_categorias count];
   
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    Category *p = [_categorias objectAtIndex:row];
    NSString *ident = [tableColumn identifier];
    NSString *columna = [p valueForKey:ident];
    
    //NSLog(@"Columnas: %@", columna);
    return columna;
}

-(void) MesageBox:(NSString *)Message andTitle:(NSString *)Title{
    NSAlert *alerta = [[NSAlert alloc] init];
    [alerta addButtonWithTitle:@"Continuar"];
    [alerta setMessageText:Title];
    [alerta setInformativeText:Message];
    [alerta setAlertStyle:NSAlertStyleInformational];
    [alerta runModal];
}

-(void) InicializarProgress{
    [_progressIndicator setHidden:NO];
    [_progressIndicator setIndeterminate:YES];
    [_progressIndicator setUsesThreadedAnimation:YES];
    [_progressIndicator startAnimation:nil];
}

-(void) FinalizarProgress{
    [_progressIndicator stopAnimation:nil];
    [_progressIndicator setHidden:YES];
}


@end
