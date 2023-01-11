--真龙斗士 十二宫·天秤
local m=914206451
local cm=_G["c"..m]
function cm.initial_effect(c)
	--summon with s/t
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_CONTINUOUS))
	e1:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e1)
    --tribute check
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(cm.valcheck)
	c:RegisterEffect(e2)
    --immune reg
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCondition(cm.regcon)
	e3:SetOperation(cm.regop)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
    --to grave
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOGRAVE)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_CHAINING)
    e4:SetRange(LOCATION_MZONE)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetCountLimit(1)
    e4:SetCondition(cm.tgcon)
    e4:SetTarget(cm.tgtg)
    e4:SetOperation(cm.tgop)
    c:RegisterEffect(e4)
end
function cm.valcheck(e,c)
	local g=c:GetMaterial()
	local typ=0
	local tc=g:GetFirst()
	while tc do
		typ=bit.bor(typ,bit.band(tc:GetOriginalType(),0x7))
		tc=g:GetNext()
	end
	e:SetLabel(typ)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local typ=e:GetLabelObject():GetLabel()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(cm.efilter)
	e1:SetLabel(typ)
	c:RegisterEffect(e1)
	if bit.band(typ,TYPE_MONSTER)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(21377582,3))
	end
	if bit.band(typ,TYPE_SPELL)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(21377582,4))
	end
	if bit.band(typ,TYPE_TRAP)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(21377582,5))
	end
end
function cm.efilter(e,te)
	return te:GetHandler():GetOriginalType()&e:GetLabel()~=0 and te:GetOwner()~=e:GetOwner()
end
function cm.tgfilter(c)
    return c:IsAbleToGrave()
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingTarget(cm.tgfilter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local tc=Duel.SelectTarget(tp,cm.tgfilter,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,tc,1,tp,LOCATION_MZONE)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)>0 then
        local v=tc:GetBaseAttack()
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(v)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        e:GetHandler():RegisterEffect(e1)
    end
end
