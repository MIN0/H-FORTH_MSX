
ARRAY( BYTE: MARK 1001 )	/* �}�[�L���O�p�z�� */

/* --- �m�̔{���̃}�[�N���������[�h�̒�` --- */

: UNMARK  PARAM( N )		/* ���[�h���� UNMARK �A�p�����[�^�� N */
VAR( I )			/* UNMARK �ł̂ݗL���ȃ��[�J���ϐ� I */

N 2 * >> I			/* I �̏����l�� N*2 */
WHILE( I 1000 <= ){		/* I<=1000 �̊Ԃ���Ԃ� */
    FALSE >> MARK [ I ]		/* I�Ԃ̃}�[�N�� FALSE �i�O�j�ɂ��� */
    I N + >> I			/* I �� N �𑫂� */
}				/* ���[�v�����܂� */
;				/* ���[�h UNMARK �̒�`�I��� */

/* --- ���C�����[�h�̒�` --- */

: MAIN				/* ���[�h���� MAIN �A�p�����[�^�Ȃ� */
VAR( I )			/* MAIN �ł̂ݗL���ȃ��[�J���ϐ� I */

"\n�P����P�O�O�O�܂őf�������߂邼�I�I\n" STR.	/* ���b�Z�[�W�\�� */

1 >> I
WHILE( I 1000 <= ){		/* 1�`1000 �܂ŁA */
    TRUE >> MARK [ I ]		/* MARK �����ׂ� TRUE �i�P�j�ɂ��� */
    I 1 + >> I
}

2 >> I
WHILE( I 1000 <= ){		/* 2�`1000 �܂ŁA */
    I UNMARK			/* ���[�h UNMARK ���Ăяo�� */
    I 1 + >> I
}

1 >> I
WHILE( I 1000 <= ){		/* 1�`1000 �܂� */
    MARK [ I ] IF{ I . }	/* MARK ���O�łȂ���� I ��\�� */
    I 1 + >> I
}
"\n�ǂ����I�I" STR.		/* �I�����b�Z�[�W�\�� */
;
END MAIN			/* �\�[�X�v���O�����I���A���C�����[�h�w�� */

