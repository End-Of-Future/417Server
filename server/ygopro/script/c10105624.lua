function c10105624.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,3,c10105624.lcheck)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10105624,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,10105624)
	e1:SetCondition(c10105624.spcon)
	e1:SetTarget(c10105624.sptg)
	e1:SetOperation(c10105624.spop)
	c:RegisterEffect(e1)
    	--cannot be battle target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetCondition(c10105624.ccon)
	e2:SetValue(aux.imval1)
	c:RegisterEffect(e2)
    	--negate attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10105624,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c10105624.damcon)
	e3:SetTarget(c10105624.damtg)
	e3:SetOperation(c10105624.damop)
	c:RegisterEffect(e3)
end
function c10105624.lcheck(g,lc)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_LINK)
end
function c10105624.filter(c,e,tp)
	return c:IsRace(RACE_BEAST) and not c:IsCode(10105624) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10105624.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c10105624.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c10105624.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c10105624.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c10105624.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c10105624.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10105624.ccon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)>1
end
function c10105624.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetOwner():IsRelateToCard(e:GetHandler())
end
function c10105624.atklimit(e,c)
	return c==e:GetOwner()
end
function c10105624.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsPosition(POS_FACEUP_ATTACK) and (Duel.GetAttacker()==c or Duel.GetAttackTarget()==c)
end
function c10105624.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dam=math.ceil(e:GetHandler():GetBattleTarget():GetBaseAttack()/2)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c10105624.damop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if Duel.NegateAttack() and bc and bc:IsRelateToBattle() and bc:IsControler(1-tp) then
		Duel.Damage(1-tp,math.ceil(bc:GetBaseAttack()/2),REASON_EFFECT)
	end
end