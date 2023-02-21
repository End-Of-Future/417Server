--幻星集 命运之占卜
function c66060030.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c66060030.condition)
	e3:SetCountLimit(1)
	e3:SetOperation(c66060030.chop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCondition(c66060030.condition1)
	e4:SetOperation(c66060030.chop1)
	c:RegisterEffect(e4)
local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c66060030.splimit)
	c:RegisterEffect(e2)
end
function c66060030.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	return Duel.ChangeChainOperation(ev,c66060030.repop)
end

function c66060030.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and Duel.GetTurnPlayer()==tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end

function c66060030.penfilter(c)
		return c:IsSetCard(0x660) and c:IsType(TYPE_PENDULUM)
end
function c66060030.repop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=2 then return end
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	local ct=g:GetCount()
	if ct>0 and Duel.GetLocationCount(tp,LOCATION_PZONE)<2 and g:FilterCount(c66060030.penfilter,nil,e,tp)>0
		and Duel.SelectYesNo(tp,aux.Stringid(66060030,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sg=g:FilterSelect(tp,c66060030.penfilter,1,1,nil,e,tp)
	local tc=sg:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
	end
end

function c66060030.condition1(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.GetTurnPlayer()==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c66060030.chop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	return Duel.ChangeChainOperation(ev,c66060030.repop1)
end
function c66060030.repop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)<=2 then return end
	Duel.ConfirmDecktop(1-tp,3)
	local g=Duel.GetDecktopGroup(1-tp,3)
	local ct=g:GetCount()
	if ct>0 and Duel.GetLocationCount(1-tp,LOCATION_PZONE)<2 and g:FilterCount(c66060030.penfilter,nil,e,1-tp)>0
		and Duel.SelectYesNo(tp,aux.Stringid(66060030,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sg=g:FilterSelect(tp,c66060030.penfilter,1,1,nil,e,tp)
	local tc=sg:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
	end
end
function c66060030.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x660) end