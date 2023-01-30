function c10105654.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c10105654.spcon)
	c:RegisterEffect(e1)
    	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e4:SetCondition(c10105654.atkcon)
	e4:SetOperation(c10105654.atkop)
	c:RegisterEffect(e4)
    	--token
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10105654,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetCountLimit(1,10105654)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c10105654.tkcon)
	e5:SetTarget(c10105654.tktg)
	e5:SetOperation(c10105654.tkop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
    end
function c10105654.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x16b) and not c:IsCode(10105654)
end
function c10105654.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c10105654.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c10105654.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function c10105654.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sync=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(-600)
	sync:RegisterEffect(e1,true)
end
function c10105654.tkcfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_WYRM)
end
function c10105654.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10105654.tkcfilter,1,nil) and not eg:IsContains(e:GetHandler())
end
function c10105654.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c10105654.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,10105655,0,TYPES_TOKEN_MONSTER,0,0,4,RACE_WYRM,ATTRIBUTE_WATER) then return end
	local token=Duel.CreateToken(tp,10105655)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end