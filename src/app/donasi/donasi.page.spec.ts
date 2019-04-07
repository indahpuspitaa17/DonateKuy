import { CUSTOM_ELEMENTS_SCHEMA } from '@angular/core';
import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { DonasiPage } from './donasi.page';

describe('DonasiPage', () => {
  let component: DonasiPage;
  let fixture: ComponentFixture<DonasiPage>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ DonasiPage ],
      schemas: [CUSTOM_ELEMENTS_SCHEMA],
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(DonasiPage);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
